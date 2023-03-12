# Introduction 

Deploy a Nexus repository to an AKS cluster.
The Nexus repository uses an Azure Storage account (File Share) for persistent storage
The Nexus repository has an optional ingress controller (that will be secured using Let's Encrypt certificates)
More details on the helm chart can be found [here](https://blog.memoryleek.co.uk/2023/02/09/deploying-and-configuring-nexus-repositories-on-aks-with-terraform.html)

Nexus requires a minimum of 4 cpu per instance, so the default VM node size needs to be set to a minimum of 8 core (e.g. something like a Standard_D8s_v3) machines.

Once deployed one option for configuring the Nexus Repository is the [Terraform Provider](https://registry.terraform.io/providers/datadrivers/nexus/latest/docs). 

Note: If you enable Ingress, you will need to update the appropriate NSG rules to allow inbound traffic from your required location. 


## Invocation in parent
``` terraform

# ########################
# xxx - NEXUS
# ########################
module "nexus_xxx" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//aks-nexus"
  # source = "../../Curtain-Wall-Modules/aks-nexus"

  nexus_instance_name               = var.xxx_nexus_instance_name
  base_name                         = "${var.base_name}-nexus-xxx"
  resource_group                    = module.rg_xxx.resource_group
  acr                               = module.rg_xxx.acr
  aks                               = module.aks_xxx.aks
  aks_managed_identity              = module.aks_xxx.aks_managed_identity
  storage_file_share_name           = var.xxx_nexus_storage_file_share_name
  enable_ingress                    = var.xxx_nexus_enable_ingress
  nexus_admin_password              = var.xxx_nexus_admin_password
  agentPoolNodeSelector             = var.xxx_nexus_agentPoolNodeSelector
  init-nexus-container-tag          = var.xxx_nexus_init_nexus_container_tag
  cluster_issuer_email              = var.xxx_nexus_cluster_issuer_email
  use_production_certificate_issuer = var.xxx_nexus_use_production_certificate_issuer
}

```

### Vars in parent
```terraform

# ########################
# xxx - NEXUS
# ########################

variable "xxx_nexus_instance_name" {
  type = string
}

variable "xxx_nexus_storage_file_share_name" {
  type = string
}

variable "xxx_nexus_enable_ingress" {
  type    = bool
  default = false
}

variable "xxx_nexus_init_nexus_container_tag" {
  type    = string
  default = "1.0"
}

variable "xxx_nexus_admin_password" {
  type = string
  sensitive = true
}

variable "xxx_nexus_agentPoolNodeSelector" {
  type = string
  default = "default"
}

variable "xxx_nexus_cluster_issuer_email" {
  type = string
}

variable "xxx_nexus_use_production_certificate_issuer" {
  type = bool
  default = false
}


```

### TFVars
```terraform

# ########################
# xxx - NEXUS
# ########################

xxx_nexus_instance_name                     = "xxx"
xxx_nexus_storage_file_share_name           = "xxx-nexus-data"
xxx_nexus_enable_ingress                    = true
xxx_nexus_agentPoolNodeSelector             = "nexus"
xxx_nexus_init_nexus_container_tag          = "1.0"
xxx_nexus_cluster_issuer_email              = "REPLACEME@TEST.COM"
xxx_nexus_use_production_certificate_issuer = false


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


