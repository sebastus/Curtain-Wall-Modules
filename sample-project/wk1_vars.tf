# ########################
# Variables relevant to the Context_wk1 Module
# ########################

#
#  * Optionally create resource group
#
variable "wk1_create_resource_group" {
  default = true
}

variable "wk1_existing_resource_group_name" {
  default = ""
}

#
#  * Optionally create Log Analytics Workspace
#
variable "wk1_create_law" {
  type    = bool
  default = true
}

#
#  * Optionally create MI
#
variable "wk1_create_managed_identity" {
  type    = bool
  default = true
}

#
#  * Optionally create ACR
#
variable "wk1_create_acr" {
  type    = bool
  default = false
}

#
#  * Optionally create vnet & subnet
#  * Otherwise, use existing
#
variable "wk1_create_vnet" {
  type    = bool
  default = true
}

# if create_vnet Is true #################
variable "wk1_new_vnet_address_space" {
  # this is a comma-delimited list of cidr
  # e.g. "10.0.0.0/16","172.16.0.0/16"
  type    = string
  default = "10.0.0.0/16"
}
# else
variable "wk1_existing_vnet_rg_name" {
  type    = string
  default = ""
}
variable "wk1_existing_vnet_rg_location" {
  type    = string
  default = ""
}
variable "wk1_existing_vnet_name" {
  type    = string
  default = ""
}
# if create_vnet Is true #################


variable "wk1_create_subnet" {
  type    = bool
  default = true
}

## if create_subnet Is true #################
variable "wk1_new_subnet_address_prefixes" {
  # this is a comma-delimited list of cidr
  type    = string
  default = "10.0.1.0/28"
}
## else
variable "wk1_existing_subnet_id" {
  type    = string
  default = ""
}
## if create_subnet Is true #################

# ########################
# P1 BigBang AKS 
# ########################
variable "wk1_create_p1bb" {
  type    = bool
  default = false
}
variable "wk1_p1bb_aks_dns_prefix" {
  type    = string
  default = ""
}
variable "wk1_p1bb_admin_username" {
  type = string
}
