# Introduction

# Invocation samples

## Invocation code in parent
```terraform

# #########################
# xxx - Linux VM from Image
# #########################

module "my-linux-vm" {
  #source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//vm-from-image-linux"
  source = "../../cs/Curtain-Wall-Modules/vm-from-image-linux"

  base_name      = "my_vm"

  resource_group = module.rg_xxx.context_outputs.resource_group
  identity_ids   = [
    module.rg_xxx.context_outputs.managed_identity == null ? null : module.rg_xxx.context_outputs.managed_identity.id
  ]
  subnet_id      = module.rg_xxx.context_outputs.well_known_subnets["default"].id

  # optionally install public ip
  create_pip = var.xxx_vfil_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_vfil_install_omsagent

  log_analytics_workspace_id = module.rg_xxx.context_outputs.log_analytics_workspace == null ? null : module.rg_xxx.context_outputs.log_analytics_workspace.workspace_id
  log_analytics_workspace_key = module.rg_xxx.context_outputs.log_analytics_workspace == null ? null : module.rg_xxx.context_outputs.log_analytics_workspace.primary_shared_key

  image_resource_group_name = var.xxx_vfil_image_resource_group_name
  image_base_name           = var.xxx_vfil_image_base_name

}

```

## variables in parent
```terraform

# #########################
# xxx - Linux VM from Image
# #########################

variable "xxx_vfil_create_pip" {
  default = false
}
variable "xxx_vfil_install_omsagent" {
  default = true
}

variable "xxx_vfil_image_resource_group_name" {
  type    = string
}
variable "xxx_vfil_image_base_name" {
  type    = string
}

```

## outputs
```terraform
# ########################
# xxx - VM From Image - Linux
# ########################
output "vm-from-image-linux" {
  value     = module.my-linux-vm
  sensitive = true
}
```

## tfvars
```terraform

# #########################
# xxx - Linux VM from Image
# #########################

xxx_vfil_create_pip       = true
xxx_vfil_install_omsagent = true

xxx_vfil_image_resource_group_name = "rg-myManagedImages"
xxx_vfil_image_base_name           = "basic-build-agent"

```

