#
# Create a new private key for each Linux VM - Only required if you ever
# wish to connect to the machine (for debugging purposes)
#
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#
# Create a new VMSS - admin account is vmssadmin
#
resource "azurerm_virtual_machine_scale_set" "linux_vmss" {
  name                   = azurecaf_name.generated["vmss"].result
  location               = var.resource_group.location
  resource_group_name    = var.resource_group.name
  overprovision          = false
  upgrade_policy_mode    = "Manual"
  single_placement_group = false

  sku {
    name     = var.vm_size
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  os_profile {
    computer_name_prefix = "linuxvmss"
    admin_username       = "vmssadmin"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/vmssadmin/.ssh/authorized_keys"
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  identity {
    type         = var.identity_ids == null ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.identity_ids
  }

  storage_profile_image_reference {
    id = data.azurerm_image.imagedata.id
  }

  network_profile {
    name    = "vmss_network"
    primary = true

    ip_configuration {
      name      = "primary"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  lifecycle {
    ignore_changes = [
      tags["__AzureDevOpsElasticPool"],
      tags["__AzureDevOpsElasticPoolTimeStamp"],
      extension,
      sku[0].capacity,
    ]
  }
}

# adding ingested image as a resource

data "azurerm_image" "imagedata" {
  name                = var.existing_image_name
  resource_group_name = var.existing_image_rg_name
}