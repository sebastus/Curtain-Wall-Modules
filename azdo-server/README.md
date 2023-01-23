# Introduction

# Invocation samples

## Invocation code in parent
```terraform
# ########################
# AzDO Server
# ########################
module "azdo-server" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//azdo-server"
  #source = "../../Curtain-Wall-Modules/azdo-server"

  base_name      = "azdo_server"
  admin_password = var.xxx_admin_password

  resource_group = module.rg_xxx.resource_group
  identity_ids   = [
    module.rg_xxx.managed_identity == null ? null : module.rg_xxx.managed_identity.id
  ]
  subnet_id      = module.rg_xxx.subnet_id

  # optionally install public ip
  create_pip = var.xxx_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_install_omsagent

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
# xxx - AzDO Server
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

variable "xxx_create_pip" {
  default = false
}

variable "xxx_install_omsagent" {
  default = true
}

```

## outputs
```terraform
# ########################
# xxx - AzDO Server
# ########################
```

## tfvars
```terraform
# ########################
# xxx - AzDO Server
# ########################
xxx_admin_password            = "xyzzy"
xxx_image_resource_group_name = "rg-myManagedImages"
xxx_image_base_name           = "azdo_server"
xxx_arm_client_id             = "a-guid"
xxx_arm_client_secret         = "a-long-and-complicated-string"
xxx_arm_installer_password    = "a-long-and-complicated-string"
xxx_local_temp                = "c:\\users\\me\\AppData\\Local\\temp"
xxx_create_pip                = false
xxx_install_omsagent          = true
```
