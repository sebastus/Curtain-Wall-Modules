module "emulated-ash" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//emulated-ash"
  #source = "../../Curtain-Wall-Modules/emulated-ash"

  base_name      = "cw-ash"

  resource_group = module.rg_xxx.resource_group
  subnet_id      = module.rg_xxx.subnet_id
  admin_password = var.xxx_ash_admin_password

  asdk_vhd_source_uri  = var.xxx_ash_vhd_source_uri
  asdk_number_of_cores = var.xxx_ash_number_of_cores

  create_managed_identity        = var.xxx_ash_create_managed_identity
  existing_managed_identity_name = var.xxx_ash_existing_managed_identity_name
  existing_managed_identity_rg   = var.xxx_ash_existing_managed_identity_rg

  create_key_vault        = var.xxx_ash_create_key_vault
  existing_key_vault_name = var.xxx_ash_existing_key_vault_name
  existing_key_vault_rg   = var.xxx_ash_existing_key_vault_rg

  create_pe_subnet              = var.xxx_ash_create_pe_subnet
  new_pe_subnet_address_prefix  = var.xxx_ash_new_pe_subnet_address_prefix
  pe_subnet_resource_group_name = var.xxx_ash_vnet_resource_group_name
  pe_subnet_vnet_name           = var.xxx_ash_vnet_name
  existing_pe_subnet_name       = var.xxx_ash_existing_pe_subnet_name
}
