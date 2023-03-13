module "vmss-ba" {
  #source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//vmss-ba"
  source = "../../Curtain-Wall-Modules/vmss-ba"

  count          = var.xxx_create_vmss_ba ? 1 : 0
  instance_index = count.index

  base_name      = var.xxx_base_name
  resource_group = module.rg_xxx.resource_group

  identity_ids           = [module.rg_xxx.context_outputs.managed_identity.id]
  subnet_id              = module.rg_xxx.context_outputs.subnet_id
  existing_image_rg_name = var.xxx_existing_image_rg_name
  existing_image_name    = var.xxx_existing_image_name
}
