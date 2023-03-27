# Overview

This module deploys a Nexus repository to an AKS cluster. The repository:
- uses an Azure Storage account (File Share) for persistent storage
- has an optional ingress controller (that will be secured using Let's Encrypt certificates)

More details on the helm chart can be found [here](https://blog.memoryleek.co.uk/2023/02/09/deploying-and-configuring-nexus-repositories-on-aks-with-terraform.html)


&nbsp;
# How to use

At the Curtain Wall modules level, run

`python codegen/src/main.py add -m aks-nexus -g {resource group name}`

Once deployed one option for configuring the Nexus Repository is the [Terraform Provider](https://registry.terraform.io/providers/datadrivers/nexus/latest/docs). 

&nbsp;
# Execution requirements

- AKS is Linux only.
- Nexus requires a minimum of 4 cpu per instance, so the default VM node size needs to be set to a minimum of 8 core (e.g. something like a Standard_D8s_v3) machines.

 

&nbsp;
# Changes you need to make

If you enable Ingress, you will need to update the appropriate NSG rules to allow inbound traffic from your required location.


&nbsp;
# References to other module outputs

- tg_{resource group}.resource_group
- tg_{resource group}.azurerm_container_registry
- aks_{resource group}.aks
- aks_{resource group}.aks_managed_identity
- container-images/nexus-init
- helm-charts/nexus


&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{resource group}_nexus_instance_name
{resource group}_nexus_storage_file_share_name
{resource group}_nexus_enable_ingress
{resource group}_nexus_init_nexus_container_tag
{resource group}_nexus_agentPoolNodeSelector
{resource group}_nexus_cluster_issuer_email
{resource group}_nexus_use_production_certificate_issuer
```