# ########################
# Variables relevant to the Remote Module
# ########################
variable "install_remote" {
  default = false
}

variable "is_hub" {
  default = false
}

variable "base_name" {
  type = string
}

variable "azdo_org_name" {
  type = string
}
variable "azdo_project_name" {
  type    = string
}
variable "azdo_pat" {
  type    = string
}
variable "azdo_arm_svc_conn" {
  type = string
  default = ""
}
variable "azurerm_backend_key" {
  type    = string
  default = ""
}


variable "cw_tfstate_name" {
  type    = string
  default = null
}
variable "cw_environment_name" {
  type    = string
  default = null
}

# ########################
# Variables relevant to the Context Module
# ########################
variable "location" {
  type    = string
  default = "uksouth"
}

variable "subscription_id" {
  type = string
}

#
#  Optionally create resource group
#
variable "create_resource_group" {
  description = "Create the resource group or ingest existing"
  default     = true
}
variable "existing_resource_group_name" {
  default = "dummy"
}

#
#  * Optionally create Log Analytics Workspace
#
variable "create_law" {
  type    = bool
  default = true
}

#
#  * Optionally create MI
#
variable "create_managed_identity" {
  type    = bool
  default = true
}
variable "existing_managed_identity_name" {
  type = string
}
variable "existing_managed_identity_rg" {
  type = string
}

#
#  * Optionally create ACR
#
variable "create_acr" {
  type    = bool
  default = false
}

#
#  * Optionally create vnet & subnet
#  * Otherwise, use existing
#
variable "create_vnet" {
  type    = bool
  default = true
}

# if create_vnet Is true #################
variable "new_vnet_address_space" {
  # this is a comma-delimited list of cidr
  # e.g. "10.0.0.0/16,172.16.0.0/16"
  type    = string
  default = "10.0.0.0/16"
}
# else
variable "existing_vnet_rg_name" {
  type    = string
  default = ""
}
variable "existing_vnet_rg_location" {
  type    = string
  default = ""
}
variable "existing_vnet_name" {
  type    = string
  default = ""
}
# if create_vnet Is true #################

variable "create_well_known_subnets" {
  type    = bool
  default = true
}