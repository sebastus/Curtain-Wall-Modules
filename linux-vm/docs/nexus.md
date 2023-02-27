### As a nexus vm

### Invocation in parent
```terraform

# ########################
# xxx - Nexus
# ########################
module "nexus" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//linux-vm"
  #source = "../../Curtain-Wall-Module/linux-vm"

  count               = var.count_of_nexus
  vm_size             = var.xxx_nx_vm_size
  instance_index      = count.index
  base_name           = "nexus"
  managed_identity_id = module.rg_xxx.managed_identity.id
  
  create_pip = true
  
  resource_group = module.rg_xxx.resource_group
  identity_ids   = [module.rg_xxx.managed_identity.id]
  subnet_id      = module.rg_xxx.subnet_id

  law_installed               = var.xxx_nx_create_law
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
# xxx - Nexus
# ########################
variable "xxx_nx_count_of_nexus" {
  default = 0
}
variable "xxx_nx_vm_size" {
  type = string
  default = "Standard_B4ms"
}

```

### outputs in parent

```terraform

# ########################
# xxx - Nexus
# ########################
output "nexus" {
  value     = var.xxx_nx_count_of_nexus != 0 ? module.nexus : null
  sensitive = true
}

```

### TFVars

```terraform

# ########################
# xxx - Nexus
# ########################
xxx_nx_count_of_nexus   = 1
xxx_nx_vm_size          = "Standard_B4ms"

```

