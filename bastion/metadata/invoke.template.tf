module "bastion" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//bastion"
  #source = "../../cs/Curtain-Wall-Modules/bastion"

  resource_group = module.rg_xxx.context_outputs.resource_group
  subnet_id      = module.rg_xxx.context_outputs.well_known_subnets["AzureBastionSubnet"].id
}
