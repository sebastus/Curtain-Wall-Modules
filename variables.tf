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
    rg     = { resource_type = "azurerm_resource_group" },
    mi     = { resource_type = "azurerm_user_assigned_identity" },
    vnet   = { resource_type = "azurerm_virtual_network" },
    subnet = { resource_type = "azurerm_subnet" },
    law    = { resource_type = "azurerm_log_analytics_workspace" },
    acr    = { resource_type = "azurerm_container_registry" },
  }
}

variable "create_resource_group" {
  description = "Create the resource group or ingest existing"
  default = true
}
variable "existing_resource_group_name" {
  default = "dummy"
}

variable "base_name" {
  type    = string
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

variable "create_subnet" {
  type = bool
}
variable "existing_subnet_id" {
  type = string
}
variable "new_subnet_address_prefixes" {
  type = list(string)
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
