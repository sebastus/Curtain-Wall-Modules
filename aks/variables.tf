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

variable "subnet_id" {
  type        = string
  description = "The azure resource id of the subnet that the aks node pools will join."
}

variable "default_aks_pool_vm_sku" {
  type    = string
  default = "Standard_D4ds_v5"

}

variable "install_cert_manager" {
  type    = bool
  default = false
}

variable "acr" {
  type = any

  validation {
    condition = var.acr != null
    error_message = "An ACR must be in the configuration in order to use the AKS module."
  }
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

  default = {
    "buildagents" = {
      vm_size    = "Standard_DS2_v2"
      node_count = 1
    }
  }
}
