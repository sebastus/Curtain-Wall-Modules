variable "xxx_node_pools" {
  description = "Optional list of additional node pools to add"
  type = map(object({
    vm_size             = string
    node_count          = number
    enable_auto_scaling = optional(bool, false)
    min_count           = optional(number, null)
    max_count           = optional(number, null)
  }))
}
