

# ############################
# Trust group: hann-test
# Instance ID: b88bb4a4-373d-4674-ac47-ebfb666d3f05
# ############################
module "tg_hann-test" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//trust-group?ref=main"
  #source = "../Curtain-Wall-Modules/trust-group"

  location     = var.location
  tg_base_name = var.hann-test_tg_base_name

  create_resource_group        = var.hann-test_create_resource_group
  existing_resource_group_name = var.hann-test_existing_resource_group_name

  create_law = var.hann-test_create_law

  create_managed_identity        = var.hann-test_create_managed_identity
  existing_managed_identity_name = var.hann-test_existing_managed_identity_name
  existing_managed_identity_rg   = var.hann-test_existing_managed_identity_rg

  create_acr = var.hann-test_create_acr

  create_kv           = var.hann-test_create_kv
  existing_kv_name    = var.hann-test_existing_kv_name
  existing_kv_rg_name = var.hann-test_existing_kv_rg_name

  create_vnet            = var.hann-test_create_vnet
  new_vnet_address_space = var.hann-test_new_vnet_address_space
  existing_vnet_rg_name  = var.hann-test_existing_vnet_rg_name
  existing_vnet_name     = var.hann-test_existing_vnet_name

  create_well_known_subnets = var.hann-test_create_well_known_subnets
  well_known_subnets        = var.hann-test_well_known_subnets

  is_tfstate_home     = var.hann-test_is_tfstate_home
  tfstate_storage_key = var.hann-test_tfstate_storage_key
}
# ############################
# END: b88bb4a4-373d-4674-ac47-ebfb666d3f05
# ############################
