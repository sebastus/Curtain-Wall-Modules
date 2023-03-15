module "aks_build_agents" {
  #source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//aks-build-agent?ref=main"
  source = "../Curtain-Wall-Modules/aks-build-agent"

  resource_group = module.tg_xxx.resource_group
  acr            = module.tg_xxx.azure_container_registry
  agent_tag      = var.agent_tag

  azdo_pat      = var.azdo_pat
  azdo_repo_url = var.azdo_repo_url

  agent_pools = var.xxx_agent_pools
}