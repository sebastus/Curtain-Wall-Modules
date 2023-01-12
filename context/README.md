# Introduction 
This Terraform module installs a few basic resources:
1. A resource group  
2. A user-assigned managed identity in the contributor role of the subscription  
3. A virtual network  
4. A subnet  
5. A default NSG for the subnet  

The module is designed to be used with the top level Terraform module in "azure-bz-tf-curtainwall-infra" repo.  
# Options
* create_vnet  
* create_subnet  
* create_managed_identity  
The VM/build agent is designed to work with a User Assigned Managed Identity. If switched on, role assignments are given so the MI can provision infrastructure.  

Some [basic information about managed identities](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types).  
And a document on [best practices and how to choose](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/managed-identity-best-practice-recommendations).

# Invocation examples

With new network:  

``` terraform
module "context" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//context"

  location = var.location

  create_managed_identity       = var.create_managed_identity
  subscription_id = data.azurerm_subscription.env.id

  create_vnet            = true
  new_vnet_address_space = split(",", var.new_vnet_address_space)

  create_subnet               = true
  new_subnet_address_prefixes = split(",", var.new_subnet_address_prefixes)

}
```

With existing network:  

``` terraform
module "context" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//context"

  location = var.location

  create_managed_identity       = var.create_managed_identity
  subscription_id = data.azurerm_subscription.env.id

  create_vnet            = false
  existing_vnet_rg_name  = var.existing_vnet_rg_name
  existing_vnet_name     = var.existing_vnet_name

  create_subnet               = false
  existing_subnet_id          = var.existing_subnet_id

}
```