#
# Create a unique NIC for each build agent VM
# 
resource "azurerm_network_interface" "build_agent" {
  name                = azurecaf_name.generated["nic"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "build_agent"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
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
# Format the cloud-init
#
data "template_cloudinit_config" "config_cloud_init" {
  for_each = var.os_variant

  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/${each.value.cloud_init_file_name}",
      {
        user = "adminbs"
      }
    )
    merge_type = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.azcli.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.terraform.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.azdo_build_agent.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}

#
# Create a new VM for the bootstrap - admin account is adminbs
#
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.os_variant

  name                  = azurecaf_name.generated["vm"].result
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.build_agent.id]
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
    azurerm_network_interface.build_agent
  ]
}

resource "azurerm_virtual_machine_extension" "omsagent" {
  for_each = var.install_omsagent ? var.os_variant : {}

  name                 = "omsagent"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm[each.key].id
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