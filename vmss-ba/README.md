# Overview

This module deploys an Azure Virtual Machine Scale Set build agent.


&nbsp;
# Execution requirements

The module vhd-or-image needs to have been installed into the same environment.
 

&nbsp;
# References to other module outputs

- resource_group
- context_outputs.managed_identity
- context_outputs.subnet_id


&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{resource group}_create_vmss_ba
{resource group}_existing_image_name
{resource group}_existing_image_rg_name
```