### As a jumpbox:  
```terraform
# ########################
# Jumpboxes
# ########################
module "jumpbox" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//linux-vm"
  #source = "../../Curtain-Wall-Modules/linux-vm"

  count            = var.xxx_count_of_jumpboxes
  instance_index   = count.index
  base_name        = "jumpbox"

  # this is passed to the finally cipart so cloud init completion can be tagged
  managed_identity = module.rg_xxx.managed_identity

  # this is passed to the vm so user assigned identity can be assigned
  identity_ids   = [module.rg_xxx.managed_identity.id]

  create_pip = false
  
  resource_group = module.rg_xxx.resource_group
  subnet_id      = module.rg_xxx.subnet_id

  law_installed               = var.xxx_create_law
  install_omsagent            = var.xxx_install_omsagent
  log_analytics_workspace_id  = module.rg_xxx.law_id
  log_analytics_workspace_key = module.rg_xxx.law_key

  include_azcli = true
}
```

### Vars in parent
```terraform
# ########################
# Jumpboxes
# ########################
variable "xxx_count_of_jumpboxes" {
  default = 0
}
variable "xxx_install_omsagent" {
  default = true
}
```

### outputs in parent
```terraform
# ########################
# Jumpboxes
# ########################
output "jumpboxes" {
  value     = var.xxx_count_of_jumpboxes != 0 ? module.jumpbox : null
  sensitive = true
}
```

### TFVars
```terraform
# #########################
# xxx jumpbox
# #########################
xxx_count_of_jumpboxes = 1
xxx_install_omsagent   = true
```

