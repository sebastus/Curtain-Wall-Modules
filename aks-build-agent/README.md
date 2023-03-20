# Overview

Deploys one or more KEDA based build agents to an AKS cluster.
Agents are implemented as Kubernetes Jobs and will scale based on the number of jobs in the queue.

&nbsp;
# How to use

At the Curtain Wall modules level, run

`python codegen/src/main.py add -m aks-build-agent -g {resource group name}`

&nbsp;
# Execution requirements

AKS-build-agent is Linux only
JQ is installed to execute, as are build agents from `../container-images/build-agent` and `/../helm-charts/keda-azdo-build-agent`. These are all done in local-exec scripts in main.tf.

&nbsp;
# Changes you need to make

An AzDO PAT is required for this module to access the AzDO project and create the variable group. When running locally export the PAT as a TF_VAR environment variable e.g. `export TF_VAR_azdo_pat=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`.  The PAT tokens need the ability to manage agent pools.


&nbsp;
# References to other module outputs

- resource_group
- azurerm_container_registry
- /../container-images/build-agent
- /../helm-charts/keda-azdo-build-agent

&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{rg name}_agent_tag = "1.0"

{rg name}_agent_pools = {
  "buildagents" = {
    azdo_agent_pool   = "BuildAgents"
    aks_node_selector = "buildagents"
  }
}
```
*{rg name}.tf:* 
```
Terraform module "aks_build_agents" 
```
