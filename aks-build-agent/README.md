# Introduction 

Deploys one or more KEDA based build agents to an AKS cluster.
Agents are implemented as Kubernetes Jobs and will scale based on the number of jobs in the queue.

## Invocation in parent
``` terraform

module "aks_build_agents" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//aks-build-agent"
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

variable "agent_pools" {
  description = "Map of Agent Pools to add"
  type = map(object({
    azdo_agent_pool   = string
    aks_node_selector = optional(string, "default")
  }))
} 

```

### TFVars
```terraform
agent_tag="1.0"
azdo_repo_url="https://dev.azure.com/<org>"
agent_pools = {
  "buildagents" = {
    azdo_agent_pool   = "BuildAgents"
    aks_node_selector = "buildagents"
  }
}


```

# Notes

Note also that an AzDO PAT is required. It is needed to access the AzDO project and create the variable group.  When running locally I recommend exporting the PAT as a TF_VAR environment variable e.g. `export TF_VAR_azdo_pat=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`.  The PAT token need the ability to manage agent pools.
