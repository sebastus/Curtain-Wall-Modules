module "rg_xxx" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//resource-group"
  #source = "../../Curtain-Wall-Modules/resource-group"

  location  = var.location
  base_name = var.xxx_base_name

  create_resource_group        = var.xxx_create_resource_group
  existing_resource_group_name = var.xxx_existing_resource_group_name

  create_managed_identity        = var.xxx_create_managed_identity
  existing_managed_identity_name = var.xxx_existing_managed_identity_name
  existing_managed_identity_rg   = var.xxx_existing_managed_identity_rg

  subscription_id         = data.azurerm_subscription.env.id

  create_vnet            = var.xxx_create_vnet
  new_vnet_address_space = var.xxx_new_vnet_address_space
  existing_vnet_rg_name  = var.xxx_existing_vnet_rg_name
  existing_vnet_name     = var.xxx_existing_vnet_name

  create_subnet               = var.xxx_create_subnet
  new_subnet_address_prefixes = var.xxx_new_subnet_address_prefixes
  existing_subnet_id          = var.xxx_existing_subnet_id

  create_law = var.xxx_create_law
  create_acr = var.xxx_create_acr

  install_remote           = var.xxx_install_remote
  is_hub                   = var.xxx_is_hub
  azdo_service_connection  = var.xxx_azdo_service_connection
  azdo_project_name        = var.xxx_azdo_project_name
  azdo_variable_group_name = var.xxx_azdo_variable_group_name

}