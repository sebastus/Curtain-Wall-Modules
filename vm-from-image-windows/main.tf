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
resource "azurerm_public_ip" "imagevm" {
  count = var.create_pip ? 1 : 0

  name                = azurecaf_name.generated["pip"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"
}

#
# Create a unique NIC for each VM
# 
resource "azurerm_network_interface" "imagevm" {

  name                = azurecaf_name.generated["nic"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "imagevm"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_pip ? azurerm_public_ip.imagevm[0].id : null
  }
}

#
# Get the managed image
#
data "azurerm_image" "imagevm" {

  resource_group_name = var.image_resource_group_name
  name                = var.image_base_name

}

#
# Create a new VM from the image - admin account is adminaz
#
resource "azurerm_windows_virtual_machine" "imagevm" {
  for_each = var.os_variant

  name                  = azurecaf_name.generated["vm"].result
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.imagevm.id]
  size                  = "Standard_D4s_v5"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.imagevm.id

  computer_name  = "imagevm"
  admin_username = "adminaz"
  admin_password = var.admin_password

  identity {
    type         = var.identity_ids == null ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.identity_ids
  }

  depends_on = [
    azurerm_network_interface.imagevm
  ]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_virtual_machine_extension" "omsagent" {
  for_each = var.install_omsagent ? var.os_variant : {}

  name                 = "omsagent"
  virtual_machine_id   = azurerm_windows_virtual_machine.imagevm[each.key].id
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