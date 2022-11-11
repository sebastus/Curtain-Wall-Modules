# Introduction 
This Terraform module supports migration of local terraform state to a remote backend in Azure blob storage.  
It creates several AzDO and Azure resources:  
1. Azure storage account  
2. Storage blob container  
3. AzDO variable group + variables  

In the top-level Terraform module is a bootstrap script and AzDO pipeline that complete the migration scenario.  

All variables are passed into the remote module so they can be copied into the AzDO variable group. The variable group is referenced in the AzDO pipeline.  

# Invocation
``` terraform
module "remote" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Remote"
  count  = var.install_remote ? 1 : 0

  azdo_pat                 = var.azdo_pat
  azdo_org_name            = var.azdo_org_name
  azdo_project_name        = var.azdo_project_name
  azdo_variable_group_name = var.azdo_variable_group_name
  azdo_service_connection  = var.azdo_service_connection

  subscription_id = data.azurerm_subscription.env.subscription_id
  resource_group  = module.context.resource_group

  create_mi = var.create_mi

  create_vnet               = var.create_vnet
  existing_vnet_name        = var.existing_vnet_name
  new_vnet_address_space    = var.new_vnet_address_space
  existing_vnet_rg_location = var.existing_vnet_rg_location
  existing_vnet_rg_name     = var.existing_vnet_rg_name

  create_subnet               = var.create_subnet
  new_subnet_address_prefixes = var.new_subnet_address_prefixes
  existing_subnet_id          = var.existing_subnet_id

  count_of_agents         = var.count_of_infra_agents
  environment_demand_name = var.environment_demand_name
  azdo_pool_name          = var.azdo_pool_name
  azdo_build_agent_name   = var.azdo_build_agent_name

  create_bastion                  = var.create_bastion
  bastion_subnet_address_prefixes = var.bastion_subnet_address_prefixes

}
```

# Notes

Note also that an AzDO PAT is required. It is needed to access the AzDO project and create the variable group.  