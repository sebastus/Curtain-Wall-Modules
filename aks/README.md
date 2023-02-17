# Introduction 

Deploy an AKS cluster with a default node pool.
AKS cluster uses Azure CNI networking.
AKS cluster has the KEDA workload_autoscaler_profile enabled.
AKS cluster creates and manages it's own managed identity.
AKS cluster is allowed to pull images from the Azure container registry.
Can add additional node pools via the node_pool variable.


## Invocation in parent
``` terraform

# ########################
# xxx - AKS
# ########################
module "aks_xxx" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//aks"
  # source = "../../Curtain-Wall-Modules/aks"

  base_name = "${var.base_name}-aks-xxx"

  admin_username  = var.xxx_aks_admin_username

  default_aks_pool_vm_sku = var.xxx_aks_default_aks_pool_vm_sku

  resource_group      = module.rg_xxx.resource_group
  vnet_name           = module.rg_xxx.vnet_name
  vnet_rg_name        = module.rg_xxx.resource_group.name
  new_subnet_address_prefixes = split(",", var.xxx_aks_subnet_address_prefixes)

  install_cert_manager = var.xxx_aks_install_cert_manager

  acr_name = module.context_hub.acr_name

  node_pools = {
    ## Example of adding a node pool
    # "test" = {
    #  vm_size = "Standard_DS2_v2"
    #  node_count = 1
    # } 
  }
}

```

### Vars in parent
```terraform

# ########################
# xxx - AKS
# ########################
variable "xxx_aks_admin_username" {
  type    = string
  default = "azureuser"
}
variable "xxx_aks_default_aks_pool_vm_sku" {
  type    = string
  default = "Standard_D4ds_v5"
}
variable "xxx_aks_subnet_address_prefixes" {
  type = string
}
variable "xxx_aks_install_cert_manager" {
  type = bool
}
variable "xxx_aks_node_pools" {
  description = "Optional list of additional node pools to add"
  type = map(object({
    vm_size             = string
    node_count          = number
    enable_auto_scaling = optional(bool, false)
    min_count           = optional(number, null)
    max_count           = optional(number, null)
  }))

  default = {}
} 

```

### TFVars
```terraform

# ########################
# xxx - AKS
# ########################

xxx_aks_admin_username = "azureuser"
xxx_aks_default_aks_pool_vm_sku = "Standard_D4ds_v5"
xxx_aks_subnet_address_prefixes = "10.1.2.0/24"
xxx_aks_install_cert_manager = false
xxx_aks_node_pools = {
    "buildagents" = {
      vm_size    = "Standard_DS2_v2"
      node_count = 1
    }
}


```

### Providers

The helm provider must be initialized in providers.tf
Note: if deploying multiple AKS clusters the multiple helm providers will need to be initialized with different aliases (This is currently untested).

```terraform

provider "helm" {
  kubernetes {
    host                   = module.aks_xxx.aks_host
    client_certificate     = base64decode(module.aks_xxx.aks_client_certificate_base64)
    client_key             = base64decode(module.aks_xxx.aks_client_key_base64)
    cluster_ca_certificate = base64decode(module.aks_xxx.aks_cluster_ca_certificate_base64)
  }
}

```

