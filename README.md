# Introduction 

## Invocation in parent
``` terraform
module "rg_hub" {
  #source = "git::https://golive@dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Resource-Group"
  source = "../cw-module-resource-group"

  install_remote = false
  is_hub         = true
  base_name      = "cwhub"

  location = var.location

  create_managed_identity = var.hub_create_managed_identity
  subscription_id         = data.azurerm_subscription.env.id

  create_vnet            = var.hub_create_vnet
  new_vnet_address_space = var.hub_new_vnet_address_space
  existing_vnet_rg_name  = var.hub_existing_vnet_rg_name
  existing_vnet_name     = var.hub_existing_vnet_name

  create_subnet               = var.hub_create_subnet
  existing_subnet_id          = var.hub_existing_subnet_id
  new_subnet_address_prefixes = var.hub_new_subnet_address_prefixes

  create_law = var.hub_create_law
  create_acr = var.hub_create_acr
}
```

### Vars in parent
```terraform
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
```

### outputs in parent
```terraform
output "state_rg_name" {
  value = module.rg_hub.state_rg_name
}

output "state_storage_name" {
  value = module.rg_hub.state_storage_name
}

output "state_container_name" {
  value = module.rg_hub.state_container_name
}

output "state_key" {
  value = module.rg_hub.state_key
}
```


### TFVars
```terraform
# ####################
# global
# ####################
location = "westeurope"

# #########################
# hub resource group
# #########################

# create a vnet or connect to an existing one
hub_create_vnet            = true
hub_new_vnet_address_space = "10.1.0.0/16"

# create a subnet or connect to an existing one
hub_create_subnet               = true
hub_new_subnet_address_prefixes = "10.1.1.0/26"

# log analytics workspace
hub_create_law = false

# azure container registry
hub_create_acr = false

# Remote
install_remote           = false
azdo_service_connection  = "go-arm-connection"
azdo_project_name        = "CurtainWall"
azdo_variable_group_name = "GOPersonalEnvironment"
```
