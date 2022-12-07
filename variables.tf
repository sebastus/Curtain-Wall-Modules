variable "resource_group" {
  type = any
}

variable "instance_index" {
  type = number
}

variable "managed_identity_id" {
  description = "Resource ID of user assigned managed identity"
  type        = string
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