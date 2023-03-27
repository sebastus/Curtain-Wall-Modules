module "vmss-ba" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//vmss-ba?ref=main"
  #source = "../../Curtain-Wall-Modules/vmss-ba"

  count          = var.xxx_create_vmss_ba ? 1 : 0
  instance_index = count.index

  base_name      = "vmss-ba"
  resource_group = module.tg_xxx.resource_group

  identity_ids           = [module.tg_xxx.managed_identity.id]
  subnet_id              = module.tg_xxx.well_known_subnets["default"].id
  existing_image_rg_name = var.xxx_existing_image_rg_name
  existing_image_name    = var.xxx_existing_image_name
}
