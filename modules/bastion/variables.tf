variable "resource_group_location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "bastion_subnet_address_prefixes" {
  type = list(string)
}

variable "bastion_nsg_rules" {
  type = list(object({
    name                       = string,
    priority                   = number,
    direction                  = string,
    destination_port_range     = string,
    destination_port_ranges    = list(string),
    source_address_prefix      = string,
    destination_address_prefix = string,
  }))

  default = [
    {
      name                       = "AllowGatewayManager",
      priority                   = 2702,
      direction                  = "Inbound",
      destination_port_range     = "443",
      destination_port_ranges    = [],
      source_address_prefix      = "GatewayManager",
      destination_address_prefix = "*",
    },
    {
      name                       = "AllowHttpsInBound",
      priority                   = 2703,
      direction                  = "Inbound",
      destination_port_range     = "443",
      destination_port_ranges    = [],
      source_address_prefix      = "Internet",
      destination_address_prefix = "*",
    },
    {
      name                       = "AllowBastionHostCommunication",
      priority                   = 2704,
      direction                  = "Inbound",
      destination_port_range     = "",
      destination_port_ranges    = ["5701", "8080"],
      source_address_prefix      = "VirtualNetwork",
      destination_address_prefix = "VirtualNetwork",
    },
    {
      name                       = "AllowAzureLoadBalancerInbound",
      priority                   = 2705,
      direction                  = "Inbound",
      destination_port_range     = "443",
      destination_port_ranges    = [],
      source_address_prefix      = "AzureLoadBalancer",
      destination_address_prefix = "*",
    },
    {
      name                       = "AllowSshRdpOutbound",
      priority                   = 100,
      direction                  = "Outbound",
      destination_port_range     = "",
      destination_port_ranges    = ["22", "3389"],
      source_address_prefix      = "*",
      destination_address_prefix = "VirtualNetwork",
    },
    {
      name                       = "AllowBastionCommunication",
      priority                   = 110,
      direction                  = "Outbound",
      destination_port_range     = "",
      destination_port_ranges    = ["8080", "5701"],
      source_address_prefix      = "VirtualNetwork",
      destination_address_prefix = "VirtualNetwork",
    },
    {
      name                       = "AllowAzureCloudOutbound",
      priority                   = 115,
      direction                  = "Outbound",
      destination_port_range     = "443",
      destination_port_ranges    = [],
      source_address_prefix      = "*",
      destination_address_prefix = "AzureCloud",
    },
    {
      name                       = "AllowGetSessionInformation",
      priority                   = 120,
      direction                  = "Outbound",
      destination_port_range     = "80",
      destination_port_ranges    = [],
      source_address_prefix      = "*",
      destination_address_prefix = "Internet",
    },
  ]
}