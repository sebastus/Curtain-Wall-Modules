
data "azurerm_subscription" "env" {}

# Context module is always installed because the resource group is needed at the very least.
module "context" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Context"

  location = var.location

  create_managed_identity = var.create_managed_identity
  subscription_id         = data.azurerm_subscription.env.id

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
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Remote"
  count  = var.install_remote ? 1 : 0

  azdo_pat                 = var.azdo_pat
  azdo_org_name            = var.azdo_org_name
  azdo_project_name        = var.azdo_project_name
  azdo_variable_group_name = var.azdo_variable_group_name
  azdo_service_connection  = var.azdo_service_connection

  subscription_id = data.azurerm_subscription.env.subscription_id
  resource_group  = module.context.resource_group

  create_managed_identity = var.create_managed_identity

  create_vnet               = var.create_vnet
  existing_vnet_name        = var.existing_vnet_name
  new_vnet_address_space    = var.new_vnet_address_space
  existing_vnet_rg_location = var.existing_vnet_rg_location
  existing_vnet_rg_name     = var.existing_vnet_rg_name

  create_subnet               = var.create_subnet
  new_subnet_address_prefixes = var.new_subnet_address_prefixes
  existing_subnet_id          = var.existing_subnet_id

  count_of_agents         = var.count_of_infra_agents
  environment_demand_name = var.environment_demand_name
  azdo_pool_name          = var.azdo_pool_name
  azdo_build_agent_name   = var.azdo_build_agent_name

  create_bastion                  = var.create_bastion
  bastion_subnet_address_prefixes = var.bastion_subnet_address_prefixes

}

module "bastion" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Bastion"
  count  = var.create_bastion ? 1 : 0

  resource_group_name             = var.create_vnet ? module.context.resource_group.name : var.existing_vnet_rg_name
  resource_group_location         = var.create_vnet ? module.context.resource_group.location : var.existing_vnet_rg_location
  vnet_name                       = var.create_vnet ? module.context.vnet_name : var.existing_vnet_name
  bastion_subnet_address_prefixes = split(",", var.bastion_subnet_address_prefixes)
}

module "build-agent" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Linux-VM"

  count               = var.count_of_infra_agents
  instance_index      = count.index
  base_name           = "build_agent"
  managed_identity_id = module.context.mi_id

  resource_group = module.context.resource_group
  identity_ids   = [module.context.mi_id]
  subnet_id      = module.context.subnet_id

  create_pip = true

  install_omsagent            = true
  log_analytics_workspace_id  = module.context.law_id
  log_analytics_workspace_key = module.context.law_key

  include_azdo_ba         = true
  azdo_agent_version      = var.azdo_agent_version
  environment_demand_name = var.environment_demand_name
  azdo_pat                = var.azdo_pat
  azdo_org_name           = var.azdo_org_name
  azdo_pool_name          = var.azdo_pool_name
  azdo_build_agent_name   = var.azdo_build_agent_name

  include_terraform = true
  terraform_version = "1.3.4"

  include_azcli = true
  include_pwsh  = true

  include_packer = true
}

module "jumpbox" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Linux-VM"

  count               = var.count_of_jumpboxes
  instance_index      = count.index
  base_name           = "jumpbox"
  managed_identity_id = module.context.mi_id

  resource_group = module.context.resource_group
  identity_ids   = null
  subnet_id      = module.context.subnet_id

  install_omsagent            = true
  log_analytics_workspace_id  = module.context.law_id
  log_analytics_workspace_key = module.context.law_key

  include_azcli = true
}

module "nexus" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Linux-VM"

  count               = var.count_of_nexus
  instance_index      = count.index
  base_name           = "nexus"
  managed_identity_id = module.context.mi_id

  create_pip = true

  resource_group = module.context.resource_group
  identity_ids   = [module.context.mi_id]
  subnet_id      = module.context.subnet_id

  install_omsagent            = true
  log_analytics_workspace_id  = module.context.law_id
  log_analytics_workspace_key = module.context.law_key

  include_azcli = true

  include_nexus = true
}

module "vmss-ba" {
  #source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-VMSS-BA"
  source = "../cw-module-vmss-ba"

  count          = var.create_vmss_ba ? 1 : 0
  instance_index = count.index
  base_name      = "bldagnt"

  resource_group = module.context.resource_group
  identity_ids   = [module.context.mi_id]
  subnet_id      = module.context.subnet_id

  managed_image_id = var.managed_image_id
}
