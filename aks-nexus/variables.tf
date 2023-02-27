variable "nexus_instance_name" {
  type = string
}

variable "resource_group" {
  type = any
}

variable "acr" {
  type = any
}

variable "aks" {
  type = any
}

variable "aks_managed_identity" {
  type = any
}

variable "singleton_resource_names" {
  type = map(object(
    {
      resource_type = optional(string,null)
    }
  ))

  default = {
    nexusstore  = { resource_type = "azurerm_storage_account" }
    nexuspublicip    = { resource_type = "azurerm_public_ip"}
  }
}

variable "base_name" {
  default = ""
}

variable "storage_file_share_name" {
  type = string
}

variable "nexus_readiness_timeout" {
  type = number
  default = 900
}

variable "enable_ingress" {
  type = bool
  default = false
}

variable "init-nexus-container-tag" {
  type = string
  default = "1.0"
}

variable "agentPoolNodeSelector" {
  type = string
  default = "default"
}

variable "nexus_admin_password" {
  type = string
  sensitive = true
}

variable "cluster_issuer_email" {
  type = string
}

variable "use_production_certificate_issuer" {
  type = bool
  default = false
}


