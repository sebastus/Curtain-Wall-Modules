
# Overview

This module is told what artefact to produce - either a VHD or an image - from which the vm-from-image modules create the VMs.

&nbsp;
# Module outputs

There are no outputs from this module.

&nbsp;
# References to other module outputs

This module does not reference other module outputs.


&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{resource group}_hcl_path_and_file_name
{resource group}_arm_client_id
{resource group}_local_temp
{resource group}_vnet_name
{resource group}_vnet_resource_group
{resource group}_vnet_subnet
{resource group}_vhd_or_image
{resource group}_image_base_name
{resource group}_image_resource_group_name
{resource group}_vhd_resource_group_name
{resource group}_vhd_capture_name_prefix
{resource group}_vhd_storage_account
```

*{rg name}.tf:* 
```
Terraform module "vhd-or-image" 
```