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
  count = false ? 1 : 0
  name = var.azdo_project_name
}

#
# Variable Group
#
resource "azuredevops_variable_group" "infra_installer" {
  name         = var.azdo_variable_group_name
  project_id   = data.azuredevops_project.curtain_wall.id
  description  = "CW variables for AzDO pipelines."
  allow_access = true

  dynamic "variable" {
    for_each = var.vg_vars
    content {
      name = variable.key
      value = variable.value
    }
  }

  dynamic "variable" {
    for_each = var.vg_secret_vars
    content {
      name = variable.key
      value = variable.value
      is_secret = true
    }
  }

  variable {
    name  = "azdo_agent_version"
    value = var.azdo_agent_version
  }

  variable {
    name  = "azdo_service_connection"
    value = var.azdo_service_connection
  }

  variable {
    name  = "state_resource_group_name"
    value = azurerm_storage_account.tfstate[0].resource_group_name
  }

  variable {
    name  = "state_storage_account_name"
    value = azurerm_storage_account.tfstate[0].name
  }

  variable {
    name  = "state_container_name"
    value = azurerm_storage_container.tfstate[0].name
  }

  variable {
    name  = "state_key"
    value = var.state_key
  }

}