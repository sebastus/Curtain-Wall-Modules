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
