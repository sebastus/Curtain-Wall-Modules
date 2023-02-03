# Introduction 
When developing new capabilities in (or debugging) Curtain Wall it's necessary to inspect outcomes directly. When Curtain Wall is installed in a private network, one way to do that is to SSH into the VM via Bastion. In cases where there is no other Bastion available, this module facilitates creation of a temporary instance.  
It creates:  
1. A Bastion subnet  
2. An NSG with the correct rules for Bastion  
3. A public IP for connecting to the Bastion  
4. The Bastion itself.  

Please note this is intended to be temporary. Remove the Bastion once debugging and research tasks are complete.  

## Invocation in parent
``` terraform
# ########################
# xxx - Bastion Module
# ########################
module "bastion" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//bastion"
  #source = "../../Curtain-Wall-Modules/bastion"

  count  = var.xxx_create_bastion ? 1 : 0

  resource_group_name             = var.xxx_create_vnet ? module.rg_xxx.resource_group.name : var.xxx_existing_vnet_rg_name
  resource_group_location         = var.xxx_create_vnet ? module.rg_xxx.resource_group.location : var.xxx_existing_vnet_rg_location
  vnet_name                       = var.xxx_create_vnet ? module.rg_xxx.vnet_name : var.xxx_existing_vnet_name
  bastion_subnet_address_prefixes = split(",", var.xxx_bastion_subnet_address_prefixes)
}
```

## Vars in parent
``` terraform
# ########################
# xxx - Bastion Module
# ########################
variable "xxx_create_bastion" {
  type    = bool
  default = false
}
variable "xxx_bastion_subnet_address_prefixes" {
  # this is a comma-delimited list of cidr
  # e.g. "10.0.2.0/26","172.16.0.0/24"
  type    = string
  default = "10.0.2.0/26"
}
```

## TFVars
```terraform
# #########################
# xxx - Bastion Module
# #########################
xxx_create_bastion                  = true
xxx_bastion_subnet_address_prefixes = "10.1.2.0/26"
```
