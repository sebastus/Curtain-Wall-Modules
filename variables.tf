# ########################
# Remote Module
# ########################
variable "azdo_project_name" {
  type = string
}

variable "azdo_variable_group_name" {
  type = string
}

variable "azdo_service_connection" {
  type = string
}

variable "resource_group" {
  type = any
}

variable "state_key" {
  type    = string
  default = "infra_installer"
}

variable "subscription_id" {
  type = string
}

# ########################
# Context Module
# ########################

#
#  * Optionally create MI
#
variable "create_managed_identity" {
  type = bool
}

#
#  * Optionally create vnet & subnet
#  * Otherwise, use existing
#
variable "create_vnet" {
  type = bool
}

# if create_vnet Is true #################
variable "new_vnet_address_space" {
  type = string
}
# else
variable "existing_vnet_name" {
  type = string
}
variable "existing_vnet_rg_name" {
  type = string
}
variable "existing_vnet_rg_location" {
  type = string
}
# if create_vnet Is true #################


variable "create_subnet" {
  type = bool
}

## if create_subnet Is true #################
variable "new_subnet_address_prefixes" {
  type = string
}
## else
variable "existing_subnet_id" {
  type = string
}
## if create_subnet Is true #################

# ########################
# Bastion Module
# ########################
variable "create_bastion" {
  type = bool
}

variable "bastion_subnet_address_prefixes" {
  type = string
}

# ########################
# Build Agent Module
# ########################
variable "count_of_agents" {
  type = number
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
