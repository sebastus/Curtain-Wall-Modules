#
# Context common to the entire CurtainWall estate
#
# Context module is always installed because the resource group is needed at the very least.
module "context" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//context?ref=118-remote-tfstate"
  #source = "../context"

  base_name = var.base_name
  location  = var.location

  create_resource_group        = var.create_resource_group
  existing_resource_group_name = var.existing_resource_group_name

  create_managed_identity        = var.create_managed_identity
  existing_managed_identity_name = var.existing_managed_identity_name
  existing_managed_identity_rg   = var.existing_managed_identity_rg

  subscription_id = var.subscription_id

  create_vnet            = var.create_vnet
  new_vnet_address_space = split(",", var.new_vnet_address_space)
  existing_vnet_rg_name  = var.existing_vnet_rg_name
  existing_vnet_name     = var.existing_vnet_name

  create_well_known_subnets = var.create_vnet || var.create_well_known_subnets

  create_law = var.create_law
  create_acr = var.create_acr
}

# Remote module creates AzDO artifacts needed to do installations with the pipeline.
module "remote" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//remote?ref=118-remote-tfstate"
  #source = "../remote"

  count  = var.install_remote ? 1 : 0
  is_hub = var.is_hub

  location                 = var.location
  resource_group           = module.context.resource_group

  azdo_org_name            = var.azdo_org_name
  azdo_project_name        = var.azdo_project_name
  azdo_pat                 = var.azdo_pat
  azdo_arm_svc_conn        = var.azdo_arm_svc_conn

  azurerm_backend_key      = var.azurerm_backend_key
  state_key                = var.azurerm_backend_key

  cw_tfstate_name          = var.cw_tfstate_name
  cw_environment_name      = var.cw_environment_name

}
