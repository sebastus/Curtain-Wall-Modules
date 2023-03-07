module "build-agent" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//linux-vm?ref=main"

  count            = var.xxx_ba_count_of_build_agents
  vm_size          = var.xxx_ba_vm_size
  instance_index   = count.index
  base_name        = "build_agent"
  managed_identity = module.rg_xxx.context_outputs.managed_identity

  resource_group = module.rg_xxx.context_outputs.resource_group
  identity_ids   = [module.rg_xxx.context_outputs.managed_identity.id]
  subnet_id      = module.rg_xxx.context_outputs.well_known_subnets["default"].id

  include_azdo_ba         = true
  azdo_pat                = var.azdo_pat
  azdo_org_name           = var.azdo_org_name
  azdo_agent_version      = var.xxx_ba_azdo_agent_version
  environment_demand_name = var.xxx_ba_environment_demand_name
  azdo_pool_name          = var.xxx_ba_azdo_pool_name
  azdo_build_agent_name   = var.xxx_ba_azdo_build_agent_name

  law_installed               = (module.rg_xxx.context_outputs.log_analytics_workspace != null)
  install_omsagent            = true
  log_analytics_workspace_id  = (module.rg_xxx.context_outputs.log_analytics_workspace != null) ? module.rg_xxx.context_outputs.log_analytics_workspace.workspace_id : null
  log_analytics_workspace_key = (module.rg_xxx.context_outputs.log_analytics_workspace != null) ? module.rg_xxx.context_outputs.log_analytics_workspace.primary_shared_key : null

  include_terraform = true
  terraform_version = "1.3.2"

  include_azcli = true
}
