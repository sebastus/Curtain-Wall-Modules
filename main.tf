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
        user               = "adminbs"                                    # adminbs
        pat_token          = var.azdo_pat                                 # /
        azdo_org           = "https://dev.azure.com/${var.azdo_org_name}" # --- These 3 must be provided by the user via ENV or pipeline params. See README.md
        build_pool         = var.azdo_pool_name                           # \
        agent_name         = "${var.azdo_build_agent_name}_${var.instance_index}"
        terraform_version  = "1.3.1"
        azdo_agent_version = var.azdo_agent_version
        hub_environment    = var.environment_demand_name
      }
    )
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
    type = "UserAssigned"
    identity_ids = [
      var.mi_id
    ]
  }

  depends_on = [
    azurerm_network_interface.build_agent
  ]
}
