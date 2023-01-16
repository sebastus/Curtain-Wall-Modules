#
# Context common to the entire CurtainWall estate
#
# Context module is always installed because the resource group is needed at the very least.
module "context" {
  source = "../context"

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

  create_subnet               = var.create_subnet
  existing_subnet_id          = var.existing_subnet_id
  new_subnet_address_prefixes = split(",", var.new_subnet_address_prefixes)

  create_law = var.create_law
  create_acr = var.create_acr
}

# Remote module creates AzDO artifacts needed to do installations with the pipeline.
module "remote" {
  source = "../remote"

  count  = var.install_remote ? 1 : 0
  is_hub = var.is_hub

  resource_group           = module.context.resource_group
  azdo_project_name        = var.azdo_project_name
  azdo_variable_group_name = var.azdo_variable_group_name
  azdo_service_connection  = var.azdo_service_connection

  vg_secret_vars = {
    "azdo_pat" = "${var.azdo_pat}",
    "state_access_key" = ""
  }

  vg_vars = {
    "install_remote" = "${var.install_remote}",
    "is_hub" = "${var.is_hub}",
    "base_name" = "${var.base_name}",
    "azdo_project_name" = "${var.azdo_project_name}",
    "azdo_variable_group_name" = "${var.azdo_variable_group_name}",
    "azdo_org_name" = "${var.azdo_org_name}",
    
    "location" = "${var.location}",
    "create_managed_identity" = "${var.create_managed_identity}",
    "existing_managed_identity_name" = "${var.existing_managed_identity_name}",
    "existing_managed_identity_rg" = "${var.existing_managed_identity_rg}",
    
    "azdo_project_name" = "${var.azdo_project_name}",
    "create_acr" = "${var.create_acr}",
    "create_law" = "${var.create_law}",
    "create_managed_identity" = "${var.create_managed_identity}",

    "create_vnet" = "${var.create_vnet}",
    "existing_vnet_name" = "${var.existing_vnet_name}",
    "new_vnet_address_space" = "${var.new_vnet_address_space}",
    "existing_vnet_rg_location" = "${var.existing_vnet_rg_location}",
    "existing_vnet_rg_name" = "${var.existing_vnet_rg_name}",

    "create_subnet" = "${var.create_subnet}",
    "new_subnet_address_prefixes" = "${var.new_subnet_address_prefixes}",
    "existing_subnet_id" = "${var.existing_subnet_id}",
  } 
}
