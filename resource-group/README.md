# Introduction 

## Invocation in parent
``` terraform

# #########################
# xxx - Resource Group 
# #########################

module "rg_xxx" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//resource-group"
  #source = "../../Curtain-Wall-Modules/resource-group"

  location  = var.location
  base_name = var.xxx_base_name

  create_resource_group        = var.xxx_create_resource_group
  existing_resource_group_name = var.xxx_existing_resource_group_name

  create_managed_identity        = var.xxx_create_managed_identity
  existing_managed_identity_name = var.xxx_existing_managed_identity_name
  existing_managed_identity_rg   = var.xxx_existing_managed_identity_rg

  subscription_id         = data.azurerm_subscription.env.id

  create_vnet            = var.xxx_create_vnet
  new_vnet_address_space = var.xxx_new_vnet_address_space
  existing_vnet_rg_name  = var.xxx_existing_vnet_rg_name
  existing_vnet_name     = var.xxx_existing_vnet_name

  create_subnet               = var.xxx_create_subnet
  new_subnet_address_prefixes = var.xxx_new_subnet_address_prefixes
  existing_subnet_id          = var.xxx_existing_subnet_id

  create_law = var.xxx_create_law
  create_acr = var.xxx_create_acr

  install_remote           = var.xxx_install_remote
  is_hub                   = var.xxx_is_hub
  azdo_service_connection  = var.xxx_azdo_service_connection
  azdo_project_name        = var.xxx_azdo_project_name
  azdo_variable_group_name = var.xxx_azdo_variable_group_name

}
```

### Vars in parent
```terraform

# #########################
# xxx - Resource Group 
# #########################

# ########################
# Variables relevant to the context module
# ########################

#
#  base name of resources
#
variable "xxx_base_name" {
  type    = string
  default = ""
}

#
#  Optionally create resource group
#
variable "xxx_create_resource_group" {
  description = "Create the resource group or ingest existing"
  default     = true
}
variable "xxx_existing_resource_group_name" {
  default = "dummy"
}

#
#  * Optionally create Log Analytics Workspace
#
variable "xxx_create_law" {
  type    = bool
  default = true
}

#
#  Optionally create managed identity
#  For use in the resource group
#
variable "xxx_create_managed_identity" {
  type    = bool
  default = true
}
variable "xxx_existing_managed_identity_name" {
  type    = string
  default = ""
}
variable "xxx_existing_managed_identity_rg" {
  type    = string
  default = ""
}

#
#  * Optionally create ACR
#
variable "xxx_create_acr" {
  type    = bool
  default = false
}

#
#  * Optionally create vnet & subnet
#  * Otherwise, use existing
#
variable "xxx_create_vnet" {
  type    = bool
  default = true
}

# if create_vnet Is true #################
variable "xxx_new_vnet_address_space" {
  # this is a comma-delimited list of cidr
  # e.g. "10.0.0.0/16","172.16.0.0/16"
  type    = string
  default = "10.0.0.0/16"
}
# else
variable "xxx_existing_vnet_rg_name" {
  type    = string
  default = ""
}
variable "xxx_existing_vnet_rg_location" {
  type    = string
  default = ""
}
variable "xxx_existing_vnet_name" {
  type    = string
  default = ""
}
# if create_vnet Is true #################


variable "xxx_create_subnet" {
  type    = bool
  default = true
}

## if create_subnet Is true #################
variable "xxx_new_subnet_address_prefixes" {
  # this is a comma-delimited list of cidr
  type    = string
  default = "10.0.1.0/28"
}
## else
variable "xxx_existing_subnet_id" {
  type    = string
  default = ""
}
## if create_subnet Is true #################

# ########################
# Variables relevant to the remote module
# ########################
variable "xxx_is_hub" {
  type    = bool
  default = false
}

variable "xxx_install_remote" {
  type    = bool
  default = false
}

variable "xxx_azdo_service_connection" {
  type    = string
  default = ""
}

variable "xxx_azdo_project_name" {
  type    = string
  default = ""
}

variable "xxx_azdo_variable_group_name" {
  type    = string
  default = ""
}
```

### outputs in parent
```terraform

# #########################
# xxx - Resource Group 
# #########################

output "rg_xxx" {
  value     = module.rg_xxx
  sensitive = true
}
```


### TFVars
```terraform

# #########################
# xxx - Resource Group 
# #########################

# context module

# base name of resources
xxx_base_name = "cw-xxx"

# optionally create the resource group
xxx_create_resource_group        = false
xxx_existing_resource_group_name = "rg-existing"

# log analytics workspace
xxx_create_law = true

# managed identity
xxx_create_managed_identity        = false
xxx_existing_managed_identity_name = "mi-cw-xxx"
xxx_existing_managed_identity_rg   = "rg-cw-existing"

# azure container registry
xxx_create_acr = false

# create a vnet or connect to an existing one
xxx_create_vnet            = true
xxx_new_vnet_address_space = "10.1.0.0/16"
xxx_existing_vnet_rg_name     = "rg_CRS_UKS_D_Networking"
xxx_existing_vnet_rg_location = "uksouth"
xxx_existing_vnet_name        = "vn_CRS_UKS_D"

# create a subnet or connect to an existing one
xxx_create_subnet               = true
xxx_new_subnet_address_prefixes = "10.1.1.0/24"
xxx_existing_subnet_id = ""

# remote module

# is this the rg with tfstate?
xxx_is_hub = false

# Remote
xxx_install_remote           = false
xxx_azdo_service_connection  = "serviceconnectionname"
xxx_azdo_project_name        = "projectname"
xxx_azdo_variable_group_name = "vgname"

```
