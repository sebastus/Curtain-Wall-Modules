variable "resource_group" {
  type = any
}

#
# Names to be generated
#
variable "singleton_resource_names" {
  type = map(object(
    {
      resource_type = string
    }
  ))

  default = {
    aks    = { resource_type = "azurerm_kubernetes_cluster" },
    subnet = { resource_type = "azurerm_subnet" },
  }
}

variable "base_name" {
  default = "cw-p1bb"
}

variable "managed_identity" {
  description = "The user assigned managed identity object."
  type        = any
}

variable "dns_prefix" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "vnet_name" {
  type = string
}
variable "vnet_rg_name" {
  type = string
}
variable "new_subnet_address_prefixes" {
  type = list(string)
  default = [
    "10.1.8.0/22"
  ]
}