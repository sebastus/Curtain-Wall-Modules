# Introduction 

## Invocation in parent
``` terraform
module "rg_xxx" {
  #source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Module-Resource-Group.CrossSight"
  source = "../cw-module-resource-group"

  install_remote = false
  is_hub         = true
  base_name      = "cwxxx"

  location = var.location

  create_managed_identity = var.xxx_create_managed_identity
  existing_managed_identity_name = var.hub_existing_managed_identity_name
  existing_managed_identity_rg   = var.hub_existing_managed_identity_rg

  subscription_id         = data.azurerm_subscription.env.id

  create_vnet            = var.xxx_create_vnet
  existing_vnet_rg_name  = var.xxx_existing_vnet_rg_name
  existing_vnet_name     = var.xxx_existing_vnet_name

  create_subnet               = var.xxx_create_subnet
  existing_subnet_id          = var.xxx_existing_subnet_id

  create_law = var.xxx_create_law
  create_acr = var.xxx_create_acr
}
```

### Vars in parent
```terraform
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
}
variable "xxx_existing_managed_identity_rg" {
  type    = string
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
  default = false
}

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

variable "xxx_create_subnet" {
  type    = bool
  default = false
}

variable "xxx_existing_subnet_id" {
  type    = string
  default = ""
}
```

### outputs in parent
```terraform
output "state_rg_name" {
  value = module.rg_xxx.state_rg_name
}

output "state_storage_name" {
  value = module.rg_xxx.state_storage_name
}

output "state_container_name" {
  value = module.rg_xxx.state_container_name
}

output "state_key" {
  value = module.rg_xxx.state_key
}
```


### TFVars
```terraform
# #########################
# xxx resource group
# #########################

# create a vnet or connect to an existing one
xxx_create_vnet = false

# create a subnet or connect to an existing one
xxx_create_subnet = false

# log analytics workspace
xxx_create_law = false

# azure container registry
xxx_create_acr = false

# managed identity
xxx_create_managed_identity        = false
xxx_existing_managed_identity_name = "mi-cwgreg"
xxx_existing_managed_identity_rg   = "rg-cwhub"

# Remote
install_remote           = false
xxx_azdo_service_connection  = "cw-arm-connection"
xxx_azdo_project_name        = "CrossSight"
xxx_azdo_variable_group_name = "CrossSightEnvironment"
```
