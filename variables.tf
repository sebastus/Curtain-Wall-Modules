# ########################
# Remote Module
# ########################
variable "install_remote" {
  type    = bool
  default = false
}

variable "azdo_project_name" {
  type = string
}

variable "azdo_variable_group_name" {
  type = string
}

variable "azdo_service_connection" {
  type = string
}

# ########################
# Context Module
# ########################
variable "location" {
  type    = string
  default = "uksouth"
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


variable "create_subnet" {
  type    = bool
  default = true
}

## if create_subnet Is true #################
variable "new_subnet_address_prefixes" {
  # this is a comma-delimited list of cidr
  type    = string
  default = "10.0.1.0/28"
}
## else
variable "existing_subnet_id" {
  type    = string
  default = ""
}
## if create_subnet Is true #################

# ########################
# Bastion Module
# ########################
variable "create_bastion" {
  type    = bool
  default = true
}

variable "bastion_subnet_address_prefixes" {
  # this is a comma-delimited list of cidr
  type    = string
  default = "10.0.2.0/26"
}

# ########################
# Build Agents
# ########################
variable "count_of_infra_agents" {
  default = 0
}

# ########################
# Jumpboxes
# ########################
variable "count_of_jumpboxes" {
  default = 0
}

# ########################
# AzDO
# ########################
variable "azdo_org_name" {
  type = string
}

variable "azdo_pat" {
  type = string
}

variable "azdo_agent_version" {
  default = "2.206.1"
}

variable "azdo_pool_name" {
  type = string
}

variable "azdo_build_agent_name" {
  type = string
}

# Options: Production, Test, or a developer's environment name
variable "environment_demand_name" {
  type = string
}

