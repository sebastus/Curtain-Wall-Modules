terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.25.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.2.2"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.17"
    }
  }
}
