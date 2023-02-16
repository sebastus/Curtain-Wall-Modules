# Introduction 

Deploys one or more KEDA based build agents to an AKS cluster.
Agents are implemented as Kubernetes Jobs and will scale based on the number of jobs in the queue.

## Invocation in parent
``` terraform

module "aks_build_agents" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//aks-build-agent"
  # source = "../../Curtain-Wall-Modules/aks-build-agent"

  resource_group      = module.rg_xxx.resource_group
  acr_name = module.rg_xxx.acr_name
  agent_tag =var.agent_tag

  azdo_pat = var.azdo_pat
  azdo_repo_url = var.azdo_repo_url

  agent_pools = {
    ##############################################
    ## Sample of a pool
    ##############################################
    # "buildagents" = {
    #  azdo_agent_pool = "BuildAgents"
    #  aks_node_selector = "test"
    }
  }

}

```

### Vars in parent
```terraform

variable "agent_tag" {
  type = string
  default = "1.0"
}

variable "azdo_pat" {
  type = string
  sensitive   = true
}

variable "azdo_repo_url" {
  type = string
}

```

### TFVars
```terraform
agent_tag="1.0"
azdo_repo_url="https://dev.azure.com/<org>"

```

# Notes

Note also that an AzDO PAT is required. It is needed to access the AzDO project and create the variable group.  When running locally I recommend exporting the PAT as a TF_VAR environment variable e.g. `export TF_VAR_azdo_pat=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`.  The PAT token need the ability to manage agent pools.
