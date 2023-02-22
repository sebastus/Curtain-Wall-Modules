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

NOTE: Context is an internal module called by Resource Group. Invoking it separately is not anticipated.  

# Invocation in parent

``` terraform
# ###################
# Context
# ###################
module "context" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//context"
  #source = "../context"

  base_name = var.base_name
  location  = var.location

  create_resource_group        = var.create_resource_group
  existing_resource_group_name = var.existing_resource_group_name

  create_managed_identity        = var.create_managed_identity
  existing_managed_identity_name = var.existing_managed_identity_name
  existing_managed_identity_rg   = var.existing_managed_identity_rg

  subscription_id = var.subscription_id

  create_vnet            = var.create_vnet
  new_vnet_address_space = split(",", var.new_vnet_address_space)
  existing_vnet_rg_name  = var.existing_vnet_rg_name
  existing_vnet_name     = var.existing_vnet_name

  create_subnet               = var.create_subnet
  existing_subnet_id          = var.existing_subnet_id
  new_subnet_address_prefixes = split(",", var.new_subnet_address_prefixes)

  create_law = var.create_law
  create_acr = var.create_acr
}
```

# Variables in parent

``` terraform
# ###################
# Context
# ###################
variable "location" {
  type    = string
  default = "uksouth"
}

variable "subscription_id" {
  type = string
}

#
#  Optionally create resource group
#
variable "create_resource_group" {
  description = "Create the resource group or ingest existing"
  default     = true
}
variable "existing_resource_group_name" {
  default = "dummy"
}

#
#  * Optionally create Log Analytics Workspace
#
variable "create_law" {
  type    = bool
  default = true
}

#
#  * Optionally create MI
#
variable "create_managed_identity" {
  type    = bool
  default = true
}
variable "existing_managed_identity_name" {
  type = string
}
variable "existing_managed_identity_rg" {
  type = string
}

#
#  * Optionally create ACR
#
variable "create_acr" {
  type    = bool
  default = false
}

#
#  * Optionally create vnet & subnet
#  * Otherwise, use existing
#
variable "create_vnet" {
  type    = bool
  default = true
}

# if create_vnet Is true #################
variable "new_vnet_address_space" {
  # this is a comma-delimited list of cidr
  # e.g. "10.0.0.0/16","172.16.0.0/16"
  type    = string
  default = "10.0.0.0/16"
}
# else
variable "existing_vnet_rg_name" {
  type    = string
  default = ""
}
variable "existing_vnet_rg_location" {
  type    = string
  default = ""
}
variable "existing_vnet_name" {
  type    = string
  default = ""
}
# if create_vnet Is true #################


variable "create_subnet" {
  type    = bool
  default = true
}

## if create_subnet Is true #################
variable "new_subnet_address_prefixes" {
  # this is a comma-delimited list of cidr
  type    = string
  default = "10.0.1.0/28"
}
## else
variable "existing_subnet_id" {
  type    = string
  default = ""
}
## if create_subnet Is true #################

```

# Outputs

``` terraform
# ###################
# Context
# ###################
output "context_outputs" {
  value = module.context
}
```

# TFVARS

Not relevant to Context because it's an internal module. Its configuration is done through Resource Group
