# Introduction 
When developing new capabilities in (or debugging) Curtain Wall it's necessary to inspect outcomes directly. When Curtain Wall is installed in a private network, one way to do that is to SSH into the VM via Bastion. In cases where there is no other Bastion available, this module facilitates creation of a temporary instance.  
It creates:  
1. A Bastion subnet  
2. An NSG with the correct rules for Bastion  
3. A public IP for connecting to the Bastion  
4. The Bastion itself.  

Please note this is intended to be temporary. Remove the Bastion once debugging and research tasks are complete.  

# Invocation example

``` terraform
module "bastion" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Bastion"
  count  = var.create_bastion ? 1 : 0

  resource_group_name             = var.create_vnet ? module.context.resource_group.name : var.existing_vnet_rg_name
  resource_group_location         = var.create_vnet ? module.context.resource_group.location : var.existing_vnet_rg_location
  vnet_name                       = var.create_vnet ? module.context.vnet_name : var.existing_vnet_name
  bastion_subnet_address_prefixes = split(",", var.bastion_subnet_address_prefixes)
}
```