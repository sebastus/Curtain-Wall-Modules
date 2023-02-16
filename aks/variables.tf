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
    aks         = { resource_type = "azurerm_kubernetes_cluster" },
    subnet      = { resource_type = "azurerm_subnet" },
    mi_aks      = { resource_type = "azurerm_user_assigned_identity" },
    rg_aks_node = { resource_type = "azurerm_resource_group" },
  }
}

variable "base_name" {
  default = ""
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
    "10.0.2.0/28"
  ]
}

variable "default_aks_pool_vm_sku" {
  type    = string
  default = "Standard_D4ds_v5"

}

variable "install_cert_manager" {
  type    = bool
  default = false
}

variable "acr_name" {
  type = string
}

variable "node_pools" {
  description = "Optional list of additional node pools to add"
  type = map(object({
    vm_size             = string
    node_count          = number
    enable_auto_scaling = optional(bool, false)
    min_count           = optional(number, null)
    max_count           = optional(number, null)
  }))

  default = {}
} 