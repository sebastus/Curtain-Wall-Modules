# Overview

This module deploys an AKS cluster with a default node pool. The AKS cluster:
-  uses Azure CNI networking
- has the KEDA workload_autoscaler_profile enabled
- creates and manages it's own managed identity
- is allowed to pull images from the Azure container registry
- Can add additional node pools via the node_pool variable

&nbsp;
# How to use

At the Curtain Wall modules level, run

`python codegen/src/codegen.py add -m aks -g {resource group name}`

&nbsp;
# Execution requirements

AKS is Linux only.

&nbsp;
# Changes you need to make

Once added to your environment, update the subnet used in the invocation script.

The AKS cluster is deployed to a network with NSG rules in place to restrict traffic.  If you add Ingress resources to the cluster you will need to add NSG rules to allow inbound traffic. 


&nbsp;
# References to other module outputs

- resource_group
- azurerm_container_registry
- well_known_subnets

&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{rg name}_aks_admin_username          = "azureuser" 
{rg name}_aks_default_aks_pool_vm_sku = "Standard_D4ds_v5" 
{rg name}_aks_install_cert_manager    = false

{rg name}_node_pools = {
  "buildagents" = {
    vm_size    = "Standard_DS2_v2"
    node_count = 1
  }
```
*{rg name}.tf:* 
```
Terraform module "aks_{rg name}" 
```
*outputs.tf:*
```
module.aks_{rg name}
```