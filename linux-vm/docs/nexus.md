### As a nexus vm

```terraform
module "nexus" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//linux-vm"

  count               = var.count_of_nexus
  instance_index      = count.index
  base_name           = "nexus"
  managed_identity_id = module.rg_xxx.managed_identity.id
  
  create_pip = true
  
  resource_group = module.rg_xxx.resource_group
  identity_ids   = [module.rg_xxx.managed_identity.id]
  subnet_id      = module.rg_xxx.subnet_id

  law_installed               = var.xxx_create_law
  install_omsagent            = true
  log_analytics_workspace_id  = module.rg_xxx.law_id
  log_analytics_workspace_key = module.rg_xxx.law_key
  
  include_azcli = true
  include_nexus = true
}
```

### Vars in parent
```terraform
# ########################
# Nexus
# ########################
variable "xxx_count_of_nexus" {
  default = 0
}
```

### outputs in parent
```terraform
output "nexus" {
  value     = var.xxx_count_of_nexus != 0 ? module.nexus : null
  sensitive = true
}
```

### TFVars
```terraform
# #########################
# xxx nexus
# #########################
xxx_count_of_nexus   = 1
```
