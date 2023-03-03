module "aks_build_agents" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//aks-build-agent"
  # source = "../../Curtain-Wall-Modules/aks-build-agent"

  resource_group = module.rg_xxx.resource_group
  acr_name       = module.rg_xxx.acr_name
  agent_tag      = var.agent_tag

  azdo_pat      = var.azdo_pat
  azdo_repo_url = var.azdo_repo_url

  agent_pools = var.agent_pools
}

