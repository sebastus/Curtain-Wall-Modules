terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.25.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.17"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.aks.kube_config.0.host
    client_certificate     = base64decode(var.aks.kube_config.0.client_certificate)
    client_key             = base64decode(var.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(var.aks.kube_config.0.cluster_ca_certificate)
  }
}