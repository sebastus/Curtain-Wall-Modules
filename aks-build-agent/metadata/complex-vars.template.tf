variable "xxx_agent_pools" {
  description = "Map of Agent Pools to add"
  type = map(object({
    azdo_agent_pool   = string
    aks_node_selector = optional(string, "default")
  }))
} 