#
# Context common to the entire CurtainWall estate
#
# Context module is always installed because the resource group is needed at the very least.
module "context" {
  #source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Context"
  source = "../cw-module-context"

  base_name = var.base_name
  location = var.location

  create_managed_identity = var.create_managed_identity
  subscription_id         = var.subscription_id

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
  #source           = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Remote"
  source           = "../cw-module-remote"
  count            = var.install_remote ? 1 : 0
  is_common_remote = var.is_common_remote
  
  resource_group           = module.context.resource_group
  azdo_project_name        = var.azdo_project_name
  azdo_variable_group_name = var.azdo_variable_group_name

  vg_secret_vars = [
    { azdo_pat : var.azdo_pat },
  ]

  vg_vars = [
    { "${var.vg_vars_prefix}_install_remote" : true },

    { "${var.vg_vars_prefix}_create_acr" : var.create_acr },
    { "${var.vg_vars_prefix}_create_law" : var.create_law },
    { "${var.vg_vars_prefix}_create_managed_identity" : var.create_managed_identity },

    { "${var.vg_vars_prefix}_create_vnet" : var.create_vnet },
    { "${var.vg_vars_prefix}_existing_vnet_name" : var.existing_vnet_name },
    { "${var.vg_vars_prefix}_new_vnet_address_space" : var.new_vnet_address_space },
    { "${var.vg_vars_prefix}_existing_vnet_rg_location" : var.existing_vnet_rg_location },
    { "${var.vg_vars_prefix}_existing_vnet_rg_name" : var.existing_vnet_rg_name },

    { "${var.vg_vars_prefix}_create_subnet" : var.create_subnet },
    { "${var.vg_vars_prefix}_new_subnet_address_prefixes" : var.new_subnet_address_prefixes },
    { "${var.vg_vars_prefix}_existing_subnet_id" : var.existing_subnet_id },
  ]
}
