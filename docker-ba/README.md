# Introduction 

WARNING: this module has not been tested recently.

## Invocation in parent

``` terraform
# ########################
# xxx - Docker BA 
# ########################
module "docker-ba" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//docker-ba"
  #source = "../../Curtain-Wall-Modules/docker-ba"

  count = var.xxx_create_docker_ba ? 1 : 0

  resource_group                = module.rg_hub.resource_group
  azdo_pat                      = var.azdo_pat
  repo_url                      = var.xxx_repo_url
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
# xxx - Docker BA 
# ########################
variable "xxx_create_docker_ba" {
  type    = bool
  default = false
}
variable "xxx_repo_url" {
  type = string
}
```

#### TFVars
```terraform

# ########################
# xxx - Docker BA 
# ########################
xxx_create_docker_ba = false
xxx_repo_url         = "https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//docker-ba"
```
