# Introduction

# Invocation samples

## Invocation code in parent
```terraform

# #########################
# xxx - Windows VM from Image
# #########################

module "azdo-server-vm" {
  #source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//windows-vm-from-image"
  source = "../../cs/Curtain-Wall-Modules/windows-vm-from-image"

  base_name      = "azdo_server"
  admin_password = var.xxx_wvfi_admin_password

  resource_group = module.rg_xxx.resource_group
  identity_ids   = [
    module.rg_xxx.managed_identity == null ? null : module.rg_xxx.managed_identity.id
  ]
  subnet_id      = module.rg_xxx.subnet_id

  # optionally install public ip
  create_pip = var.xxx_wvfi_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_wvfi_install_omsagent

  log_analytics_workspace_id = module.rg_xxx.law_id
  log_analytics_workspace_key = module.rg_xxx.law_key

  image_resource_group_name = var.xxx_wvfi_image_resource_group_name
  image_base_name           = var.xxx_wvfi_image_base_name

}

```

## variables in parent
```terraform

# #########################
# xxx - Windows VM from Image
# #########################

variable "xxx_wvfi_admin_password" {
  type = string
}

variable "xxx_wvfi_image_resource_group_name" {
  type    = string
}

variable "xxx_wvfi_image_base_name" {
  type    = string
}

variable "xxx_wvfi_create_pip" {
  default = false
}
variable "xxx_wvfi_install_omsagent" {
  default = true
}

```

## outputs
```terraform
```

## tfvars
```terraform

# #########################
# xxx - Windows VM from Image
# #########################

xxx_wvfi_admin_password   = "P@ssw0rd!"
xxx_wvfi_create_pip       = true
xxx_wvfi_install_omsagent = true

xxx_wvfi_image_resource_group_name = "rg-myManagedImages"
xxx_wvfi_image_base_name           = "azdo-server"

```

