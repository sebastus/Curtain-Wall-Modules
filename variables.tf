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

variable "azdo_pat" {
  type = string
}

