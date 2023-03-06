# ########################
# Globally relevant defaults
# ########################
variable "location" {
  description = "Default location for all resource groups"
  default     = "uksouth"
}

variable "azdo_org_name" {
  description = "i.e. https://dev.azure.com/<azdo_org_name>"
  type        = string
}

variable "azdo_project_name" {
  description = "Name of the AzDO project in the org that contains pipelines & variable groups."
  type        = string
}

variable "azdo_pat" {
  type = string
}

variable "azdo_arm_svc_conn" {
  description = "Name of existing AzDO ARM service connection in the org."
  type        = string
}

variable "azurerm_backend_key" {
  description = "The name of the tfstate file in the azurerm backend storage container."
  type        = string
}

variable "cw_environment_name" {
  description = "The name of the folder containing the cw rg files."
  type        = string
}