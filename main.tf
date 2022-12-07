resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_subnet" "subnet" {
  name                 = azurecaf_name.generated["subnet"].result
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.new_subnet_address_prefixes
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vnet_name}-${azurerm_subnet.subnet.name}-nsg-${var.resource_group.location}"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
}

resource "azurerm_subnet_network_security_group_association" "subnetnsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_kubernetes_cluster" "main" {
  name = azurecaf_name.generated["aks"].result

  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  default_node_pool {
    name           = "default"
    node_count     = 3
    vm_size        = "Standard_D4ds_v5"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  dns_prefix = var.dns_prefix

  network_profile {
    network_plugin = "azure"
  }
}