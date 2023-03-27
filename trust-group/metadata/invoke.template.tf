module "tg_xxx" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//trust-group?ref=main"
  #source = "../Curtain-Wall-Modules/trust-group"

  location     = var.location
  tg_base_name = var.xxx_tg_base_name

  create_resource_group        = var.xxx_create_resource_group
  existing_resource_group_name = var.xxx_existing_resource_group_name

  create_law = var.xxx_create_law

  create_managed_identity        = var.xxx_create_managed_identity
  existing_managed_identity_name = var.xxx_existing_managed_identity_name
  existing_managed_identity_rg   = var.xxx_existing_managed_identity_rg

  create_acr = var.xxx_create_acr

  create_kv               = var.xxx_create_kv
  make_created_kv_private = var.xxx_make_created_kv_private
  keyvault_pe_subnet_id   = module.tg_xxx.well_known_subnets["PrivateEndpointsSubnet"].id
  existing_kv_name        = var.xxx_existing_kv_name
  existing_kv_rg_name     = var.xxx_existing_kv_rg_name

  create_platform_vpn = var.xxx_create_platform_vpn

  create_vnet            = var.xxx_create_vnet
  new_vnet_address_space = var.xxx_new_vnet_address_space
  existing_vnet_rg_name  = var.xxx_existing_vnet_rg_name
  existing_vnet_name     = var.xxx_existing_vnet_name

  # edit tg_hub to point to peered vnet if required
  peer_vnet_with_another = var.xxx_peer_vnet_with_another
  peered_vnet            = var.xxx_peer_vnet_with_another ? module.tg_hub.vnet : null

  include_openvpn_mods     = var.xxx_include_openvpn_mods
  openvpn_client_cidr     = var.xxx_openvpn_client_cidr
  openvpn_client_next_hop = var.xxx_openvpn_client_next_hop

  create_well_known_subnets = var.xxx_create_well_known_subnets
  well_known_subnets        = var.xxx_well_known_subnets

  is_tfstate_home     = var.xxx_is_tfstate_home
  tfstate_storage_key = var.xxx_tfstate_storage_key
}
