#
# network
#
resource "azurerm_virtual_network" "vnet" {
  count = var.create_vnet ? 1 : 0

  name                = azurecaf_name.generated["vnet"].result
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = split(",", var.new_vnet_address_space)
}

locals {
  vnet_name = var.create_vnet ? azurerm_virtual_network.vnet[0].name : var.existing_vnet_name
  vnet_rg   = var.create_vnet ? azurerm_virtual_network.vnet[0].resource_group_name : var.existing_vnet_rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.create_vnet ? azurerm_virtual_network.vnet[0].name : var.existing_vnet_name
  resource_group_name = var.create_vnet ? azurerm_virtual_network.vnet[0].resource_group_name : var.existing_vnet_rg_name
}

resource "azurerm_subnet" "well_known_subnets" {
  for_each = var.create_well_known_subnets ? var.well_known_subnets : {}

  name                 = each.key
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.create_well_known_subnets ? var.well_known_subnets : {}

  name                = "${local.vnet_name}-${azurerm_subnet.well_known_subnets[each.key].name}-nsg-${var.location}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}

resource "azurerm_network_security_rule" "bastionnsgrules" {
  for_each = var.create_well_known_subnets ? var.bastion_nsg_rules : {}

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port_range == "" ? null : each.value.destination_port_range
  destination_port_ranges     = length(each.value.destination_port_ranges) == 0 ? null : each.value.destination_port_ranges
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg["AzureBastionSubnet"].name
}

resource "azurerm_subnet_network_security_group_association" "subnetnsg" {
  for_each = var.create_well_known_subnets ? var.well_known_subnets : {}

  subnet_id                 = azurerm_subnet.well_known_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id

  depends_on = [
    azurerm_network_security_rule.bastionnsgrules
  ]
}

data "azurerm_subnet" "well_known_subnets" {
  for_each = var.well_known_subnets

  name                 = each.key
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [
    azurerm_subnet.well_known_subnets
  ]
}

resource "azurerm_route_table" "openvpn" {
  count = var.include_openvpn_mods ? 1 : 0

  name                          = azurecaf_name.generated["route"].result
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  disable_bgp_route_propagation = false

  route {
    name                   = "vpnToClient"
    address_prefix         = var.openvpn_client_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.openvpn_client_next_hop
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_route_table_association" "openvpn" {
  for_each = var.include_openvpn_mods ? {
    for name, subnet in var.well_known_subnets : name => subnet
    if name != "AzureBastionSubnet"
  } : {}

  subnet_id = data.azurerm_subnet.well_known_subnets[each.key].id
  route_table_id = azurerm_route_table.openvpn[0].id
}