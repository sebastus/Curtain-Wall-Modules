# Introduction 

This module deploys an AKS cluster with a default node pool. The AKS cluster:
-  uses Azure CNI networking
- has the KEDA workload_autoscaler_profile enabled
- creates and manages it's own managed identity
- is allowed to pull images from the Azure container registry
- Can add additional node pools via the node_pool variable

&nbsp;
# How to use

At the Curtain Wall modules level, run

`python codegen/src/main.py add -m aks -g {resource group name}`

Once added to your environment, update the subnet used in the module.

The AKS cluster is deployed to a network with NSG rules in place to restrict traffic.  If you add Ingress resources to the cluster you will need to add NSG rules to allow inbound traffic. 

&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{rg name}_aks_admin_username          = "azureuser" 
{rg name}_aks_default_aks_pool_vm_sku = "Standard_D4ds_v5" 
{rg name}_aks_install_cert_manager    = false
```
*{rg name}.tf:* 
```
Terraform module "aks_{rg name}" 
```
*outputs.tf:*
```
module.aks_{rg name}
```
