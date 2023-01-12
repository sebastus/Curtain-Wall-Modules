# Introduction 


## Invocation in parent
``` terraform
module "docker-ba" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//docker-ba"

  count = var.create_docker_ba ? 1 : 0

  resource_group                = module.rg_hub.resource_group
  azdo_pat                      = var.azdo_pat
  repo_url                      = var.repo_url
  azurerm_container_registry_id = module.rg_hub.acr_id
  identity_ids                  = [module.rg_hub.managed_identity.id]

  container-envvars = {
    AZP_URL        = "https://dev.azure.com/${var.azdo_org_name}",
    AZP_TOKEN      = "${var.azdo_pat}"
    AZP_POOL       = "myPool"
    AZP_AGENT_NAME = "cw-docker"
  }
}
```

#### Vars in parent
```terraform
# ########################
# Docker BA 
# ########################
variable "create_docker_ba" {
  type    = bool
  default = false
}
variable "repo_url" {
  type = string
}
```

#### TFVars
```terraform
# docker ba
repo_url = "https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//docker-ba"
```
