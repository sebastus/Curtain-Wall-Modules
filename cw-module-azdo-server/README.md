# Introduction

# Invocation samples

## Invocation code in parent
```terraform
# ########################
# AzDO Server
# ########################
module "azdo-server" {
  #source = "git::https://CrossSight@dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Module-AzDO-Server.CrossSight"
  source = "../cw-module-azdo-server"

  base_name      = "azdo_server"
  admin_password = var.xxx_admin_password

  resource_group = module.rg_xxx.resource_group
  identity_ids   = [
    module.rg_xxx.managed_identity == null ? null : module.rg_xxx.managed_identity.id
  ]
  subnet_id      = module.rg_xxx.subnet_id

  # optionally install public ip
  create_pip = false

  # optionally install oms agent
  install_omsagent = true

  log_analytics_workspace_id = module.rg_xxx.law_id
  log_analytics_workspace_key = module.rg_xxx.law_key
}
```

## variables in parent
```terraform
# ########################
# AzDO Server
# ########################
variable "xxx_admin_password" {
    type = string
}
```

## outputs
```terraform
# ########################
# AzDO Server
# ########################
```

## tfvars
```terraform
# ########################
# xxx AzDO Server
# ########################
xxx_admin_password = "xyzzy"
```
