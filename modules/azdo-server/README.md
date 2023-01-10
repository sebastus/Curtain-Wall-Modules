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

  image_resource_group_name = var.xxx_image_resource_group_name
  image_base_name           = var.xxx_image_base_name

  arm_client_id          = var.xxx_arm_client_id
  arm_client_secret      = var.xxx_arm_client_secret
  arm_installer_password = var.xxx_arm_installer_password

  local_temp             = var.xxx_local_temp

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
variable "xxx_image_resource_group_name" {
  type = string
}

variable "xxx_image_name" {
  type = string
}

variable "xxx_arm_client_id" {
  type = string
}

variable "xxx_arm_client_secret" {
  type = string
}

variable "xxx_arm_installer_password" {
  type = string
}

variable "xxx_local_temp" {
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
xxx_admin_password            = "xyzzy"
xxx_image_resource_group_name = "rg-myManagedImages"
xxx_image_base_name           = "azdo_server"
xxx_arm_client_id             = "a-guid"
xxx_arm_client_secret         = "a-long-and-complicated-string"
xxx_arm_installer_password    = "a-long-and-complicated-string"
xxx_local_temp                = "c:\\users\\me\\AppData\\Local\\temp"
```
