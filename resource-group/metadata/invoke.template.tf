module "rg_xxx" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//resource-group?ref=merge-from-cs-again"
  #source = "../../Curtain-Wall-Modules/resource-group"

  location  = var.location
  base_name = var.xxx_base_name

  create_resource_group        = var.xxx_create_resource_group
  existing_resource_group_name = var.xxx_existing_resource_group_name

  create_managed_identity        = var.xxx_create_managed_identity
  existing_managed_identity_name = var.xxx_existing_managed_identity_name
  existing_managed_identity_rg   = var.xxx_existing_managed_identity_rg

  subscription_id = data.azurerm_subscription.env.id

  create_vnet            = var.xxx_create_vnet
  new_vnet_address_space = var.xxx_new_vnet_address_space
  existing_vnet_rg_name  = var.xxx_existing_vnet_rg_name
  existing_vnet_name     = var.xxx_existing_vnet_name

  create_well_known_subnets = var.xxx_create_well_known_subnets
  well_known_subnets        = var.xxx_well_known_subnets
  
  create_law = var.xxx_create_law
  create_acr = var.xxx_create_acr

  install_remote = var.xxx_install_remote
  is_hub         = var.xxx_is_hub

  azdo_org_name     = var.azdo_org_name
  azdo_project_name = var.azdo_project_name
  azdo_arm_svc_conn = var.azdo_arm_svc_conn
  azdo_pat          = var.azdo_pat

  azurerm_backend_key = var.azurerm_backend_key

  cw_environment_name = var.cw_environment_name

}
