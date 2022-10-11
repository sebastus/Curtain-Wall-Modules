terraform {
  backend "azurerm" {
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.25.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.17"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.2.2"
    }
  }
}

provider "azurerm" {
  features {
  }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/${var.azdo_org_name}"
  personal_access_token = var.azdo_pat
}