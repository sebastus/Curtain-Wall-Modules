  # Overview

When developing new capabilities in (or debugging) Curtain Wall it's necessary to inspect outcomes directly. When Curtain Wall is installed in a private network, one way to do that is to SSH into the VM via Bastion. In cases where there is no other Bastion available, this module facilitates creation of a temporary instance.  
It creates:  
1. A Bastion subnet  
2. An NSG with the correct rules for Bastion  
3. A public IP for connecting to the Bastion  
4. The Bastion itself.  

Please note this is intended to be temporary. Remove the Bastion once debugging and research tasks are complete.

&nbsp;
# References to other module outputs

- resource_group
- well_known_subnets["AzureBastionSubnet"]

&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{resource group}_create_bastion
{resource group}_bastion_subnet_address_prefixes
```
*{rg name}.tf:* 
```
Terraform module "bastion" 
```
