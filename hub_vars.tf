# ########################
# Variables relevant to the context module
# ########################
#
#  * Optionally create Log Analytics Workspace
#
variable "hub_create_law" {
  type    = bool
  default = true
}

#
#  Optionally create managed identity
#  For use in the resource group
#
variable "hub_create_managed_identity" {
  type    = bool
  default = true
}

#
#  * Optionally create ACR
#
variable "hub_create_acr" {
  type    = bool
  default = false
}

#
#  * Optionally create vnet & subnet
#  * Otherwise, use existing
#
variable "hub_create_vnet" {
  type    = bool
  default = true
}

# if create_vnet Is true #################
variable "hub_new_vnet_address_space" {
  # this is a comma-delimited list of cidr
  # e.g. "10.0.0.0/16","172.16.0.0/16"
  type    = string
  default = "10.0.0.0/16"
}
# else
variable "hub_existing_vnet_rg_name" {
  type    = string
  default = ""
}
variable "hub_existing_vnet_rg_location" {
  type    = string
  default = ""
}
variable "hub_existing_vnet_name" {
  type    = string
  default = ""
}
# if create_vnet Is true #################


variable "hub_create_subnet" {
  type    = bool
  default = true
}

## if create_subnet Is true #################
variable "hub_new_subnet_address_prefixes" {
  # this is a comma-delimited list of cidr
  type    = string
  default = "10.0.1.0/28"
}
## else
variable "hub_existing_subnet_id" {
  type    = string
  default = ""
}
## if create_subnet Is true #################

# ########################
# Variables relevant to the remote module
# ########################
variable "hub_install_remote" {
  type    = bool
  default = false
}

# ########################
# Bastion Module
# ########################
variable "hub_create_bastion" {
  type    = bool
  default = false
}
variable "hub_bastion_subnet_address_prefixes" {
  # this is a comma-delimited list of cidr
  # e.g. "10.0.2.0/26","172.16.0.0/24"
  type    = string
  default = "10.0.2.0/26"
}

# ########################
# Build Agents
# ########################
variable "hub_count_of_build_agents" {
  default = 0
}
variable "hub_azdo_agent_version" {
  default = "2.206.1"
}
variable "hub_azdo_pool_name" {
  type = string
}
variable "hub_azdo_build_agent_name" {
  type = string
}
# Options: Production, Test, or a developer's environment name
variable "hub_environment_demand_name" {
  type = string
}
