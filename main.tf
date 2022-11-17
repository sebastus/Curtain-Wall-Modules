#
# Create a PIP for each build agent VM
# 
resource "azurerm_public_ip" "linux_vm" {
  count = var.create_pip ? 1 : 0

  name                = azurecaf_name.generated["pip"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"
}

#
# Create a unique NIC for each build agent VM
# 
resource "azurerm_network_interface" "linux_vm" {
  name                = azurecaf_name.generated["nic"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "linux_vm"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_pip ? azurerm_public_ip.linux_vm[0].id : null
  }
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
# Create a new VM for the bootstrap - admin account is adminbs
# WITH build agent 
#
resource "azurerm_linux_virtual_machine" "vm-with-ba" {
  for_each = var.include_azdo_ba ? var.os_variant : {}

  name                  = azurecaf_name.generated["vm"].result
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.linux_vm.id]
  size                  = "Standard_B2ms"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

  dynamic "plan" {
    for_each = each.value.plan == null ? [] : [each.value.plan]
    content {
      name      = plan.value["name"]
      publisher = plan.value["publisher"]
      product   = plan.value["product"]
    }
  }

  computer_name                   = "build-agent-${var.instance_index}"
  admin_username                  = "adminbs"
  disable_password_authentication = true
  custom_data                     = data.template_cloudinit_config.config_cloud_init[each.key].rendered

  admin_ssh_key {
    username   = "adminbs"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  identity {
    type         = var.identity_ids == null ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.identity_ids
  }

  provisioner "local-exec" {
    command = "${var.powershell_command} -c ${path.module}/agent-is-online.ps1 -org ${var.azdo_org_name} -pool ${var.azdo_pool_name} -demand ${var.environment_demand_name}"    
  }

  depends_on = [
    azurerm_network_interface.linux_vm
  ]
}

resource "azurerm_virtual_machine_extension" "omsagent-with-ba" {
  for_each = var.include_azdo_ba ? var.os_variant : {}

  name                 = "omsagent"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm-with-ba[each.key].id
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

#
# Create a new VM for the bootstrap - admin account is adminbs
# WITHOUT build agent 
#
resource "azurerm_linux_virtual_machine" "vm-without-ba" {
  for_each = var.include_azdo_ba ? {} : var.os_variant

  name                  = azurecaf_name.generated["vm"].result
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.linux_vm.id]
  size                  = "Standard_B2ms"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

  dynamic "plan" {
    for_each = each.value.plan == null ? [] : [each.value.plan]
    content {
      name      = plan.value["name"]
      publisher = plan.value["publisher"]
      product   = plan.value["product"]
    }
  }

  computer_name                   = "build-agent-${var.instance_index}"
  admin_username                  = "adminbs"
  disable_password_authentication = true
  custom_data                     = data.template_cloudinit_config.config_cloud_init[each.key].rendered

  admin_ssh_key {
    username   = "adminbs"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  identity {
    type         = var.identity_ids == null ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.identity_ids
  }

  depends_on = [
    azurerm_network_interface.linux_vm
  ]
}

resource "azurerm_virtual_machine_extension" "omsagent-without-ba" {
  for_each = var.include_azdo_ba ? {} : var.os_variant

  name                 = "omsagent"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm-without-ba[each.key].id
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