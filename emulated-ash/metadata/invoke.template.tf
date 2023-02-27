module "emulated-ash" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//emulated-ash"
  #source = "../../cs/Curtain-Wall-Modules/emulated-ash"

  base_name      = "cw-ash"

  resource_group = module.rg_xxx.context_outputs.resource_group
  subnet_id      = module.rg_xxx.context_outputs.well_known_subnets["default"].id
  admin_password = var.xxx_ash_admin_password

  asdk_vhd_source_uri  = var.xxx_ash_vhd_source_uri
  asdk_number_of_cores = var.xxx_ash_number_of_cores

  create_managed_identity        = var.xxx_ash_create_managed_identity
  existing_managed_identity_name = module.rg_xxx.context_outputs.managed_identity.name
  existing_managed_identity_rg   = module.rg_xxx.context_outputs.managed_identity.resource_group_name

  create_key_vault        = var.xxx_ash_create_key_vault
  existing_key_vault_name = var.xxx_ash_existing_key_vault_name
  existing_key_vault_rg   = var.xxx_ash_existing_key_vault_rg

  pe_subnet_resource_group_name = module.rg_xxx.context_outputs.vnet.resource_group_name
  pe_subnet_vnet_name           = module.rg_xxx.context_outputs.vnet.name
  existing_pe_subnet_name       = "PrivateEndpointsSubnet"
}
