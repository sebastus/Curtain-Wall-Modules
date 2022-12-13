### As a build agent:  
```terraform
module "build-agent" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-VM"
  #source = "../cw-module-linux-vm"

  count            = var.xxx_count_of_build_agents
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

  install_omsagent        = false

  include_terraform = true
  terraform_version = "1.3.2"

  include_azcli = true
}
```

### Vars in parent
```terraform
# ########################
# Build Agents
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
```

### outputs in parent
```terraform
output "build-agents" {
  value     = var.xxx_count_of_infra_agents != 0 ? module.build-agent : null
  sensitive = true
}
```

### TFVars
```terraform
# #########################
# xxx build-agent
# #########################
xxx_count_of_build_agents   = 1
xxx_azdo_agent_version      = "2.206.1"
xxx_azdo_pool_name          = "myPool"
xxx_azdo_build_agent_name   = "agent"
xxx_environment_demand_name = "myDemand"
```
