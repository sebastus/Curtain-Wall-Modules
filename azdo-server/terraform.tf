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
    packer = {
      source = "toowoxx/packer"
    }
  }
}

data "packer_version" "version" {}

data "azurerm_subscription" "env" {}
