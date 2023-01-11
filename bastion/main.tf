#
# bastion subnet & subnet nsg
#
resource "azurerm_subnet" "bastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.bastion_subnet_address_prefixes
}

resource "azurerm_network_security_group" "bastion_nsg" {
  name                = azurecaf_name.generated["bastion_nsg"].result
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_network_security_rule" "bastionnsgrules" {
  count = length(var.bastion_nsg_rules)

  name                        = var.bastion_nsg_rules[count.index].name
  priority                    = var.bastion_nsg_rules[count.index].priority
  direction                   = var.bastion_nsg_rules[count.index].direction
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = var.bastion_nsg_rules[count.index].destination_port_range == "" ? null : var.bastion_nsg_rules[count.index].destination_port_range
  destination_port_ranges     = length(var.bastion_nsg_rules[count.index].destination_port_ranges) == 0 ? null : var.bastion_nsg_rules[count.index].destination_port_ranges
  source_address_prefix       = var.bastion_nsg_rules[count.index].source_address_prefix
  destination_address_prefix  = var.bastion_nsg_rules[count.index].destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "bastion_nsg" {
  subnet_id                 = azurerm_subnet.bastionsubnet.id
  network_security_group_id = azurerm_network_security_group.bastion_nsg.id

  depends_on = [
    azurerm_network_security_rule.bastionnsgrules,
  ]
}

#
# bastion pip
#
resource "azurerm_public_ip" "bastion_pip" {
  name                = azurecaf_name.generated["bastion_pip"].result
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#
# bastion host
#
resource "azurerm_bastion_host" "bastion" {
  name                = azurecaf_name.generated["bastion"].result
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

