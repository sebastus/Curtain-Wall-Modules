
data "azurerm_subscription" "env" {}

module "rg_hub" {
  source = "../cw-module-resource-group"

  install_remote = var.hub_install_remote
  is_hub         = true
  base_name      = "cwhub"

  location = var.location

  create_managed_identity = var.hub_create_managed_identity
  subscription_id         = data.azurerm_subscription.env.id

  create_vnet            = var.hub_create_vnet
  new_vnet_address_space = var.hub_new_vnet_address_space
  existing_vnet_rg_name  = var.hub_existing_vnet_rg_name
  existing_vnet_name     = var.hub_existing_vnet_name

  create_subnet               = var.hub_create_subnet
  existing_subnet_id          = var.hub_existing_subnet_id
  new_subnet_address_prefixes = var.hub_new_subnet_address_prefixes

  create_law = var.hub_create_law
  create_acr = var.hub_create_acr
}

module "bastion" {
  #source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Bastion"
  source = "../cw-module-bastion"
  count  = var.hub_create_bastion ? 1 : 0

  resource_group_name             = var.hub_create_vnet ? module.rg_hub.resource_group.name : var.hub_existing_vnet_rg_name
  resource_group_location         = var.hub_create_vnet ? module.rg_hub.resource_group.location : var.hub_existing_vnet_rg_location
  vnet_name                       = var.hub_create_vnet ? module.rg_hub.vnet_name : var.hub_existing_vnet_name
  bastion_subnet_address_prefixes = split(",", var.hub_bastion_subnet_address_prefixes)
}

module "build-agent" {
  #source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-VM"
  source = "../cw-module-linux-vm"

  count            = var.hub_count_of_build_agents
  instance_index   = count.index
  base_name        = "build_agent"
  managed_identity = module.rg_hub.managed_identity

  resource_group = module.rg_hub.resource_group
  identity_ids   = [module.rg_hub.managed_identity.id]
  subnet_id      = module.rg_hub.subnet_id

  include_azdo_ba         = true
  azdo_pat                = var.azdo_pat
  azdo_org_name           = var.azdo_org_name
  azdo_agent_version      = var.hub_azdo_agent_version
  environment_demand_name = var.hub_environment_demand_name
  azdo_pool_name          = var.hub_azdo_pool_name
  azdo_build_agent_name   = var.hub_azdo_build_agent_name

  install_omsagent        = false

  include_terraform = true
  terraform_version = "1.3.2"

  include_azcli = true
}
