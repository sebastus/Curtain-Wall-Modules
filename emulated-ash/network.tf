#
# vnet rg
#
data "azurerm_resource_group" "vnet_rg" {
  name = var.vnet_resource_group_name
}

#
# vnet
#
data "azurerm_virtual_network" "vnet" {
  name                = var.vnetName
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
}

#
# subnet for Private Endpoints
#
resource "azurerm_subnet" "pe_subnet" {
  name                 = "PrivateEndpointsSubnet"
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
  virtual_network_name = var.vnetName
  address_prefixes     = var.pe_subnet_address_prefixes
}

locals {
  vnet_location = data.azurerm_resource_group.vnet_rg.location
}

#
# nsg for PrivateEndpointsSubnet
#
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vnetName}-${azurerm_subnet.pe_subnet.name}-nsg-${local.vnet_location}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

#
# associate the subnet & nsg
#
resource "azurerm_subnet_network_security_group_association" "subnetnsg" {
  subnet_id                 = azurerm_subnet.pe_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 
# Private DNS zone
#
resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group.name
}

#
# Private DNS Zone link to virtual network
#
resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
  name                  = "kv_private_dns_zone_link"
  resource_group_name   = var.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}