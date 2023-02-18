module "bastion" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//bastion"
  #source = "../../Curtain-Wall-Modules/bastion"

  count  = var.xxx_create_bastion ? 1 : 0

  resource_group_name             = var.xxx_create_vnet ? module.rg_xxx.resource_group.name : var.xxx_existing_vnet_rg_name
  resource_group_location         = var.xxx_create_vnet ? module.rg_xxx.resource_group.location : var.xxx_existing_vnet_rg_location
  vnet_name                       = var.xxx_create_vnet ? module.rg_xxx.vnet_name : var.xxx_existing_vnet_name
  bastion_subnet_address_prefixes = split(",", var.xxx_bastion_subnet_address_prefixes)
}
