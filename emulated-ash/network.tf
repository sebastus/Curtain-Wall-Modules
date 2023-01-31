#
# vnet rg
#
data "azurerm_resource_group" "vnet_rg" {
  name = var.pe_subnet_resource_group_name
}

#
# vnet
#
data "azurerm_virtual_network" "vnet" {
  name                = var.pe_subnet_vnet_name
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
}

#
# subnet for Private Endpoints
#
resource "azurerm_subnet" "pe_subnet" {
  count = var.create_pe_subnet ? 1 : 0

  name                 = "PrivateEndpointsSubnet"
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
  virtual_network_name = var.pe_subnet_vnet_name
  address_prefixes     = var.new_pe_subnet_address_prefixes
}

locals {
  pe_subnet_name = var.create_pe_subnet ? "PrivateEndpointsSubnet" : var.existing_pe_subnet_name
}

data "azurerm_subnet" "pe_subnet" {
  name                 = local.pe_subnet_name
  virtual_network_name = var.pe_subnet_vnet_name
  resource_group_name  = var.pe_subnet_resource_group_name
}

locals {
  vnet_location = data.azurerm_resource_group.vnet_rg.location
}

#
# nsg for PrivateEndpointsSubnet
# Assume if pe_subnet already exists, so does the NSG
#
resource "azurerm_network_security_group" "nsg" {
  count               = var.create_pe_subnet ? 1 : 0
  name                = "${var.pe_subnet_vnet_name}-${local.pe_subnet_name}-nsg-${local.vnet_location}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

#
# associate the subnet & nsg
# Assume if pe_subnet already exists, so does the NSG
#
resource "azurerm_subnet_network_security_group_association" "subnetnsg" {
  count                     = var.create_pe_subnet ? 1 : 0
  subnet_id                 = data.azurerm_subnet.pe_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

# 
# Private DNS zone
#
resource "azurerm_private_dns_zone" "kv" {
  count = var.create_key_vault ? 1 : 0

  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group.name
}

#
# Private DNS Zone link to virtual network
#
resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
  count = var.create_key_vault ? 1 : 0

  name                  = "kv_private_dns_zone_link"
  resource_group_name   = var.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.kv[0].name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}