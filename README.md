# Introduction 
This Terraform module adds various Azure resources to the top-level Terraform module for Curtain Wall. The main new resource is an AzDO build agent based on the selected operating system and tools. The VM is created, tools installed, and finally the build agent is added to the designated AzDO agent pool.  
It creates:  
1. A network interface card for the VM  
2. An SSH key pair  
3. A cloud-init script
4. VMs (according to count) with the selected Operating System and tools

# Options
The cloud-init is constructed as a base + snippets. The snippets (called ciparts - cloud-init parts) are selected with option vars.  
* include_terraform  
* include_azcli  
* include_azdo_ba  

# Invocation examples 

As a build agent:  
```terraform
module "build-agent" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-VM"

  count          = var.count_of_infra_agents
  instance_index = count.index
  base_name      = "build_agent"

  resource_group = module.context.resource_group
  identity_ids   = [module.context.mi_id]
  subnet_id      = module.context.subnet_id

  include_azdo_ba         = true
  azdo_agent_version      = var.azdo_agent_version
  environment_demand_name = var.environment_demand_name
  azdo_pat                = var.azdo_pat
  azdo_org_name           = var.azdo_org_name
  azdo_pool_name          = var.azdo_pool_name
  azdo_build_agent_name   = var.azdo_build_agent_name

  include_terraform = true
  terraform_version = "1.3.2"

  include_azcli = true
}
```

As a jumpbox:  
```terraform
module "jumpbox" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-VM"

  count          = var.count_of_jumpboxes
  instance_index = count.index
  base_name      = "jumpbox"

  resource_group = module.context.resource_group
  identity_ids   = null
  subnet_id      = module.context.subnet_id

  include_azcli = true
}
```

# Notes
Note that variables.tf contains additional information on how to select and configure the operating system selection. That configuration also includes the cloud-init selection.  

Note also that an AzDO PAT is required. It is needed to add the new build agent to the agent pool.  

Note [cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/index.html).