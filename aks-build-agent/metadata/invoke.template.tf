module "aks_build_agents" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//aks-build-agent?ref=main"
  #source = "../Curtain-Wall-Modules/aks-build-agent"

  resource_group = module.tg_xxx.resource_group
  acr            = module.tg_xxx.azurerm_container_registry
  agent_tag      = var.xxx_agent_tag

  aks = module.aks_xxx.aks

  azdo_pat      = var.azdo_pat
  azdo_repo_url = "https://dev.azure.com/${var.azdo_org_name}"

  agent_pools = var.xxx_agent_pools
}