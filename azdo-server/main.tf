#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = var.base_name
  resource_type = each.value.resource_type
}

#
# Create a PIP for each VM
# 
resource "azurerm_public_ip" "azdo_vm" {
  count = (var.vhd_or_image == "image") && var.create_pip && var.create_vm ? 1 : 0

  name                = azurecaf_name.generated["pip"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"
}

#
# Create a unique NIC for each VM
# 
resource "azurerm_network_interface" "azdo_vm" {
  count = (var.vhd_or_image == "image") && var.create_vm ? 1 : 0

  name                = azurecaf_name.generated["nic"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "azdo_vm"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_pip ? azurerm_public_ip.azdo_vm[0].id : null
  }
}

#
# Get the image definition 
#
data "packer_files" "azdo_server_hcl" {
  file = "${path.module}/azdo-server.pkr.hcl"
}

locals {
  image_name = var.image_base_name
}

#
# get the resource group where the vhd or image will go
# packer resources must be in the same region
#
data "azurerm_resource_group" "rg_artefact" {
  name = var.vhd_or_image == "vhd" ? var.vhd_resource_group_name : var.image_resource_group_name
}

#
# Generate the managed image using packer
#
resource "packer_image" "azdo_server_image" {
  file  = data.packer_files.azdo_server_hcl.file
  force = true

  environment = {
    ARM_RESOURCE_LOCATION = data.azurerm_resource_group.rg_artefact.location

    VHD_OR_IMAGE = var.vhd_or_image
    # if vhd
    VHD_CAPTURE_CONTAINER_NAME = var.vhd_capture_container_name
    VHD_CAPTURE_NAME_PREFIX    = var.vhd_capture_name_prefix
    VHD_RESOURCE_GROUP_NAME    = var.vhd_resource_group_name
    VHD_STORAGE_ACCOUNT        = var.vhd_storage_account
    # else if image
    ARM_MANAGED_IMAGE_RG_NAME = var.image_resource_group_name
    ARM_MANAGED_IMAGE_NAME    = local.image_name
    # end

    ARM_USE_INTERACTIVE_AUTH                = false
    ARM_TENANT_ID                           = data.azurerm_subscription.env.tenant_id
    ARM_SUBSCRIPTION_ID                     = data.azurerm_subscription.env.subscription_id
    ARM_CLIENT_ID                           = var.arm_client_id
    ARM_CLIENT_SECRET                       = var.arm_client_secret
    ARM_INSTALLER_PASSWORD                  = var.arm_installer_password
    ARM_VIRTUAL_NETWORK_NAME                = var.vnet_name
    ARM_VIRTUAL_NETWORK_RESOURCE_GROUP_NAME = var.vnet_rg_name
    ARM_VIRTUAL_NETWORK_SUBNET_NAME         = var.subnet_name
    TMP                                     = var.local_temp
  }

  ignore_environment = true

  triggers = {
    files_hash = data.packer_files.azdo_server_hcl.files_hash
  }
}

#
# Get the managed image
#
data "azurerm_image" "azdo_server" {
  count = var.vhd_or_image == "image" ? 1 : 0

  resource_group_name = var.image_resource_group_name
  name                = local.image_name

  depends_on = [
    packer_image.azdo_server_image
  ]
}

#
# Create a new azdo server VM - admin account is adminaz
#
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = (var.vhd_or_image == "image") && var.create_vm ? var.os_variant : {}

  name                  = azurecaf_name.generated["vm"].result
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.azdo_vm[0].id]
  size                  = "Standard_D4s_v5"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.azdo_server[0].id

  computer_name  = "azdo-server"
  admin_username = "adminaz"
  admin_password = var.admin_password

  identity {
    type         = var.identity_ids == null ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.identity_ids
  }

  depends_on = [
    azurerm_network_interface.azdo_vm[0]
  ]
}

resource "azurerm_virtual_machine_extension" "omsagent" {
  for_each = (var.vhd_or_image == "image") && var.install_omsagent && var.create_vm ? var.os_variant : {}

  name                 = "omsagent"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[each.key].id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  settings = <<SETTINGS
{
  "workspaceId": "${var.log_analytics_workspace_id}",
  "skipDockerProviderInstall": true
}
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
{
  "workspaceKey": "${var.log_analytics_workspace_key}"
}
PROTECTED_SETTINGS

}