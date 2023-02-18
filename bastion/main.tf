#
# bastion pip
#
resource "azurerm_public_ip" "bastion_pip" {
  name                = azurecaf_name.generated["bastion_pip"].result
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#
# bastion host
#
resource "azurerm_bastion_host" "bastion" {
  name                = azurecaf_name.generated["bastion"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

