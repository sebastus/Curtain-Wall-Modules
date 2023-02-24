variable "location" {
  type = string
}

variable "subscription_id" {
  type = string
}

#
# Names to be generated
#
variable "singleton_resource_names" {
  type = map(object(
    {
      resource_type = string,
    }
  ))

  default = {
    rg   = { resource_type = "azurerm_resource_group" },
    mi   = { resource_type = "azurerm_user_assigned_identity" },
    vnet = { resource_type = "azurerm_virtual_network" },
    law  = { resource_type = "azurerm_log_analytics_workspace" },
    acr  = { resource_type = "azurerm_container_registry" },
  }
}

variable "create_resource_group" {
  description = "Create the resource group or ingest existing"
  default     = true
}
variable "existing_resource_group_name" {
  default = "dummy"
}

variable "base_name" {
  type = string
}

variable "create_vnet" {
  type = bool
}
variable "new_vnet_address_space" {
  type = list(string)
}
variable "existing_vnet_rg_name" {
  type    = string
  default = ""
}
variable "existing_vnet_name" {
  type    = string
  default = ""
}

variable "create_well_known_subnets" {
  type = bool
}
variable "well_known_subnets" {
  type = map(object({
    address_prefix = string
  }))
  default = {
    default = {
      address_prefix = "10.1.0.0/24"
    },
    AzureBastionSubnet = {
      address_prefix = "10.1.1.0/24"
    },
    PrivateEndpointsSubnet = {
      address_prefix = "10.1.2.0/24"
    }
  }
}

variable "create_managed_identity" {
  type = bool
}
variable "existing_managed_identity_name" {
  type = string
}
variable "existing_managed_identity_rg" {
  type = string
}

variable "create_law" {
  type = bool
}

variable "create_acr" {
  type    = bool
  default = false
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