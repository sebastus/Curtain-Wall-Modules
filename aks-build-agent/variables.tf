variable "resource_group" {
  type = any
}

variable "acr_name" {
  type = string
}

variable "agent_tag" {
  type    = string
  default = "1.0"
}

variable "azdo_pat" {
  type      = string
  sensitive = true
}

variable "azdo_repo_url" {
  type = string
}

variable "agent_pools" {
  description = "Map of Agent Pools to add"
  type = map(object({
    azdo_agent_pool   = string
    aks_node_selector = optional(string, "default")
  }))
} 