# Overview

This module deploys an Azure Virtual Machine Scale Set build agent.


&nbsp;
# Execution requirements

The managed image of the new build agent is an input to this module. It can be built using the vm-or-image module.

&nbsp;
# Module outputs

There are no outputs from this module.

&nbsp;
# References to other module outputs

- tg_{resource group}.resource_group
- tg_{resource group}.managed_identity
- tg_{resource group}.well_known_subnets


&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{resource group}_create_vmss_ba
{resource group}_existing_image_name
{resource group}_existing_image_rg_name
```

*{rg name}.tf:* 
```
Terraform module "vmss-ba" 
```