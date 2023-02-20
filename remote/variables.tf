# ########################
# Remote Module
# ########################
variable "location" {
  type = string
}
variable "resource_group" {
  type = any
}

variable "azdo_org_name" {
  type = string
}
variable "azdo_project_name" {
  type = string
}
variable "azdo_pat" {
  type = string
}
variable "azdo_service_connection" {
  type = string
}

variable "azurerm_backend_key" {
  type = string
}

variable "cw_tfstate_name" {
  type = string
}

variable "cw_environment_name" {
  type = string
}

variable "is_hub" {
  default = false
}

variable "state_key" {
  type    = string
  default = "infra_installer"
}

variable "azdo_agent_version" {
  default = "2.206.1"
}
