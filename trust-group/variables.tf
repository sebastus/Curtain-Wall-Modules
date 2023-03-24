#
# Names to be generated
#
variable "singleton_resource_names" {
  type = map(object(
    {
      base_name     = string,
      resource_type = string,
      random_length = number
    }
  ))

  default = {
    rg                = { resource_type = "azurerm_resource_group", base_name = "", random_length = 0 },
    mi                = { resource_type = "azurerm_user_assigned_identity", base_name = "", random_length = 0 },
    vnet              = { resource_type = "azurerm_virtual_network", base_name = "", random_length = 0 },
    law               = { resource_type = "azurerm_log_analytics_workspace", base_name = "", random_length = 4 },
    acr               = { resource_type = "azurerm_container_registry", base_name = "", random_length = 4 },
    kv                = { resource_type = "azurerm_key_vault", base_name = "", random_length = 4 },
    tfstate_sa        = { resource_type = "azurerm_storage_account", base_name = "tf", random_length = 4 },
    tfstate_container = { resource_type = "azurerm_storage_container", base_name = "tfstate", random_length = 0 },
    virtual_wan       = { resource_type = "azurerm_virtual_wan", base_name = "vpn", random_length = 0 },
    virtual_hub       = { resource_type = "azurerm_virtual_hub", base_name = "vpn", random_length = 0 },
    p2s_vpn           = { resource_type = "azurerm_point_to_site_vpn_gateway", base_name = "vpn", random_length = 0 },
    route             = { resource_type = "azurerm_route_table", base_name = "vpn", random_length = 0 },
    pe-kv             = { resource_type = "azurerm_private_endpoint", base_name = "", random_length = 0 },
    peer_out          = { resource_type = "azurerm_virtual_network_peering", base_name = "peer_out", random_length = 0 },
    peer_in           = { resource_type = "azurerm_virtual_network_peering", base_name = "peer_in", random_length = 0 },
  }
}

variable "is_tfstate_home" {
  type = bool
}

variable "tfstate_storage_key" {
  type = string
}

variable "location" {
  type = string
}

variable "tg_base_name" {
  type = string
}

#
#  Optionally create resource group
#
variable "create_resource_group" {
  type = string
}
variable "existing_resource_group_name" {
  type = string
}

#
#  * Optionally create Log Analytics Workspace
#
variable "create_law" {
  type = bool
}

#
#  * Optionally create MI
#
variable "create_managed_identity" {
  type    = bool
  default = true
}
variable "existing_managed_identity_name" {
  type = string
}
variable "existing_managed_identity_rg" {
  type = string
}

#
#  * Optionally create ACR
#
variable "create_acr" {
  type = bool
}

#
#  * Optionally create Key Vault
#  * Otherwise, use existing
#
variable "create_kv" {
  type = bool
}
variable "make_created_kv_private" {
  type = bool
}
variable "keyvault_pe_subnet_id" {
  type = string
}

# if create kv is false
variable "existing_kv_rg_name" {
  type = string
}
variable "existing_kv_name" {
  type = string
}

# 
# optionally create a platform vpn gateway
#
variable "create_platform_vpn" {
  type    = bool
  default = false
}

#
#  * Optionally create vnet & subnet
#  * Otherwise, use existing
#
variable "create_vnet" {
  type    = bool
  default = true
}

# if create_vnet Is true #################
variable "new_vnet_address_space" {
  # this is a comma-delimited list of cidr
  # e.g. "10.0.0.0/16,172.16.0.0/16"
  type = string
}
# else
variable "existing_vnet_rg_name" {
  type = string
}
variable "existing_vnet_name" {
  type = string
}
# END: if create_vnet Is true #############

variable "create_well_known_subnets" {
  type = bool
}
variable "well_known_subnets" {
  type = map(object({
    address_prefix = string
  }))
}

# Include OpenVPN resources, such as route table
variable "include_openvpn_mods" {
  type = bool
}
variable "openvpn_client_cidr" {
  type = string
}
variable "openvpn_client_next_hop" {
  type = string
}

# Peer the vnet in this trust-group with another
variable "peer_vnet_with_another" {
  type = bool
}
variable "peered_vnet" {
  type = any
}


variable "default_subnet_nsg_rules" {
  type = map(object({
    priority                   = number,
    direction                  = string,
    destination_port_range     = string,
    destination_port_ranges    = list(string),
    source_address_prefix      = string,
    destination_address_prefix = string,
  }))

  default = {
    AllowOpenVPNInbound = {
      priority                   = 100,
      direction                  = "Inbound",
      destination_port_range     = "1194",
      destination_port_ranges    = [],
      source_address_prefix      = "*",
      destination_address_prefix = "*",
    },
  }
}

variable "bastion_nsg_rules" {
  type = map(object({
    priority                   = number,
    direction                  = string,
    destination_port_range     = string,
    destination_port_ranges    = list(string),
    source_address_prefix      = string,
    destination_address_prefix = string,
  }))

  default = {
    AllowGatewayManager = {
      priority                   = 2702,
      direction                  = "Inbound",
      destination_port_range     = "443",
      destination_port_ranges    = [],
      source_address_prefix      = "GatewayManager",
      destination_address_prefix = "*",
    },
    AllowHttpsInBound = {
      priority                   = 2703,
      direction                  = "Inbound",
      destination_port_range     = "443",
      destination_port_ranges    = [],
      source_address_prefix      = "Internet",
      destination_address_prefix = "*",
    },
    AllowBastionHostCommunication = {
      priority                   = 2704,
      direction                  = "Inbound",
      destination_port_range     = "",
      destination_port_ranges    = ["5701", "8080"],
      source_address_prefix      = "VirtualNetwork",
      destination_address_prefix = "VirtualNetwork",
    },
    AllowAzureLoadBalancerInbound = {
      priority                   = 2705,
      direction                  = "Inbound",
      destination_port_range     = "443",
      destination_port_ranges    = [],
      source_address_prefix      = "AzureLoadBalancer",
      destination_address_prefix = "*",
    },
    AllowSshRdpOutbound = {
      priority                   = 100,
      direction                  = "Outbound",
      destination_port_range     = "",
      destination_port_ranges    = ["22", "3389"],
      source_address_prefix      = "*",
      destination_address_prefix = "VirtualNetwork",
    },
    AllowBastionCommunication = {
      priority                   = 110,
      direction                  = "Outbound",
      destination_port_range     = "",
      destination_port_ranges    = ["8080", "5701"],
      source_address_prefix      = "VirtualNetwork",
      destination_address_prefix = "VirtualNetwork",
    },
    AllowAzureCloudOutbound = {
      priority                   = 115,
      direction                  = "Outbound",
      destination_port_range     = "443",
      destination_port_ranges    = [],
      source_address_prefix      = "*",
      destination_address_prefix = "AzureCloud",
    },
    AllowGetSessionInformation = {
      priority                   = 120,
      direction                  = "Outbound",
      destination_port_range     = "80",
      destination_port_ranges    = [],
      source_address_prefix      = "*",
      destination_address_prefix = "Internet",
    },
  }
}