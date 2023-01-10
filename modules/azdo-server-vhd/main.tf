terraform {
  required_providers {
    packer = {
      source = "toowoxx/packer"
    }
  }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.25.0"
    }
}

provider "packer" {}

data "packer_version" "version" {}

data "packer_files" "azdo_server_hcl" {
  file = "azdo-server.pkr.hcl"
}

resource "packer_image" "azdo_server_image" {
  file = data.packer_files.azdo_server_hcl.file

  triggers = {
    files_hash = data.packer_files.azdo_server_hcl.files_hash
  }
}

data "azurerm_image" "azdo_server" {
  name = "azdo_server_abcd"
  resource_group_name = "rg-managed-images"

  depends_on = [
    packer_image.azdo_server_image
  ]
}

