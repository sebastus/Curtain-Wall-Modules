module "bastion" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//bastion?ref=main"
  #source = "../../cs/Curtain-Wall-Modules/bastion"

  resource_group = module.tg_xxx.resource_group
  subnet_id      = module.tg_xxx.well_known_subnets["AzureBastionSubnet"].id
}
