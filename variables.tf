variable "location" {
  type = string
}

variable "subscription_id" {
  type = string
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

variable "create_law" {
  type = bool
}

variable "create_acr" {
  type    = bool
  default = false
}
