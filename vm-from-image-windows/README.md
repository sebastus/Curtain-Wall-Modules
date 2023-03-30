# Overview

This module creates a Windows VM from an artefact made by the vhd-or-image module.

&nbsp;
# Execution requirements

Ensure the managed image artefact exists before building a vm using this module. The managed image can be created by the vhd-or-image module.

&nbsp;
# Module outputs

```
output "vm-from-image-windows" {
  value     = azurerm_windows_virtual_machine.imagevm
  sensitive = true
}
```

&nbsp;
# References to other module outputs

- tg_{resource group}.resource_group
- tg_{resource group}.managed_identity.id
- tg_{resource group}.well_known_subnets
- tg_{resource group}.azurerm_key_vault
- tg_{resource group}.create_law
- tg_{resource group}.log_analytics_workspace


&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{resource group}_vfiw_image_resource_group_name
{resource group}_vfiw_image_base_name
{resource group}_vfiw_create_pip
{resource group}_vfiw_install_omsagent

```

*{rg name}.tf:* 
```
Terraform module "my-windows-vm" 