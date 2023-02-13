### As a build agent:  
```terraform

# ########################
# xxx - Build Agents
# ########################
module "build-agent" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//linux-vm?ref=golive"

  count            = var.xxx_count_of_build_agents
  vm_size          = var.xxx_vm_size
  instance_index   = count.index
  base_name        = "build_agent"
  managed_identity = module.rg_xxx.managed_identity

  resource_group = module.rg_xxx.resource_group
  identity_ids   = [module.rg_xxx.managed_identity.id]
  subnet_id      = module.rg_xxx.subnet_id

  include_azdo_ba         = true
  azdo_pat                = var.azdo_pat
  azdo_org_name           = var.azdo_org_name
  azdo_agent_version      = var.xxx_azdo_agent_version
  environment_demand_name = var.xxx_environment_demand_name
  azdo_pool_name          = var.xxx_azdo_pool_name
  azdo_build_agent_name   = var.xxx_azdo_build_agent_name

  law_installed               = var.xxx_create_law
  install_omsagent            = true
  log_analytics_workspace_id  = module.rg_xxx.law_id
  log_analytics_workspace_key = module.rg_xxx.law_key

  include_terraform = true
  terraform_version = "1.3.2"

  include_azcli = true
}

```

### Vars in parent
```terraform

# ########################
# xxx - Build Agents
# ########################
variable "xxx_count_of_build_agents" {
  default = 0
}
variable "xxx_azdo_agent_version" {
  default = "2.206.1"
}
variable "xxx_azdo_pool_name" {
  type = string
}
variable "xxx_azdo_build_agent_name" {
  type = string
}
# Options: Production, Test, or a developer's environment name
variable "xxx_environment_demand_name" {
  type = string
}
variable "xxx_vm_size" {
  type = string
  default = "Standard_D4ds_v5"
}

```

### outputs in parent
```terraform

# ########################
# xxx - Build Agents
# ########################
output "build-agents" {
  value     = var.xxx_count_of_build_agents != 0 ? module.build-agent : null
  sensitive = true
}

```

### TFVars
```terraform

# ########################
# xxx - Build Agents
# ########################
xxx_count_of_build_agents   = 1
xxx_azdo_agent_version      = "2.206.1"
xxx_azdo_pool_name          = "myPool"
xxx_azdo_build_agent_name   = "agent"
xxx_environment_demand_name = "myDemand"
xxx_vm_size                 = "Standard_D4ds_v5"

```
