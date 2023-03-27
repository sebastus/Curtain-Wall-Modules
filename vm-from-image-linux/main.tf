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
# Create a new private key for each Linux VM - Only required if you ever
# wish to connect to the machine (for debugging purposes)
#
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#
# and store it in key vault
#
resource "azurerm_key_vault_secret" "ssh" {
  name         = "${replace(azurecaf_name.generated["vm"].result, "_", "-")}-private-key-ssh"
  value        = tls_private_key.ssh.private_key_openssh
  key_vault_id = var.key_vault.id
}

#
# Create a new VM from the image - admin account is adminaz
#
resource "azurerm_linux_virtual_machine" "imagevm" {
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

  computer_name                   = "imagevm"
  admin_username                  = "adminaz"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "adminaz"
    public_key = tls_private_key.ssh.public_key_openssh
  }

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
  for_each = var.law_installed && var.install_omsagent ? var.os_variant : {}

  name                 = "omsagent"
  virtual_machine_id   = azurerm_linux_virtual_machine.imagevm[each.key].id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.14"

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