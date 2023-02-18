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

data "azurerm_subnet" "pe_subnet" {
  name                 = var.existing_pe_subnet_name
  virtual_network_name = var.pe_subnet_vnet_name
  resource_group_name  = var.pe_subnet_resource_group_name
}

locals {
  vnet_location = data.azurerm_resource_group.vnet_rg.location
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