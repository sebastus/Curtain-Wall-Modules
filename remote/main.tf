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
  name         = "${var.azurerm_backend_key}__${var.cw_environment_name}__core"
  project_id   = data.azuredevops_project.curtain_wall.id
  description  = "CW core variables for AzDO pipelines."
  allow_access = true

  dynamic "variable" {
    for_each = local.core_variables
    content {
      name = variable.key
      value = variable.value["value"]
      secret_value = variable.value["secret_value"]
      is_secret = variable.value["is_secret"]
    }
  }
}

# this must be kept in sync with the schema.json in the metadata folder
locals {
  core_variables = {
    "azdo_pat" = {
      secret_value = var.azdo_pat
      value = ""
      is_secret = true
    },
    "azdo_org_name" = {
      secret_value = ""
      value = var.azdo_org_name
      is_secret = false
    },
    "location" = {
      secret_value = ""
      value = var.location
      is_secret = false
    },
    "azdo_arm_svc_conn" = {
      secret_value = ""
      value     = var.azdo_arm_svc_conn
      is_secret = false
    },
    "azdo_project_name" = {
      secret_value = ""
      value     = var.azdo_project_name
      is_secret = false
    },
    "azurerm_backend_key" = {
      secret_value = ""
      value     = var.azurerm_backend_key
      is_secret = false
    },
    "cw_environment_name" = {
      secret_value = ""
      value     = var.cw_environment_name
      is_secret = false
    }

  }
}