#
# remote tfstate storage
#
resource "azurerm_storage_account" "tfstate" {
  count = var.is_hub ? 1 : 0

  name                     = azurecaf_name.generated["tfstate_sa"].result
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  count = var.is_hub ? 1 : 0

  name                  = azurecaf_name.generated["tfstate_container"].result
  storage_account_name  = azurerm_storage_account.tfstate[0].name
  container_access_type = "private"
}

#
# AzDO project
#
data "azuredevops_project" "curtain_wall" {
  name = var.azdo_project_name
}

#
# Variable Group
#
resource "azuredevops_variable_group" "core" {
  name         = "${var.cw_tfstate_name}__${var.cw_environment_name}__core"
  project_id   = data.azuredevops_project.curtain_wall.id
  description  = "CW core variables for AzDO pipelines."
  allow_access = true

  dynamic "variable" {
    for_each = local.core_variables
    content {
      name = variable.key
      value = variable.value["value"]
      is_secret = variable.value["is_secret"]
    }
  }
}

locals {
  core_variables = {
    "azdo_pat" = {
      value = var.azdo_pat
      is_secret = true
    },
    "azdo_org_name" = {
      value = var.azdo_org_name
      is_secret = false
    },
    "location" = {
      value = var.location
      is_secret = false
    },
    "azdo_service_connection" = {
      value     = var.azdo_service_connection
      is_secret = false
    },
    "azdo_project_name" = {
      value     = var.azdo_project_name
      is_secret = false
    }

  }
}