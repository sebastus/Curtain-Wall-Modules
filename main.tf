#
# AzDO project
#
data "azuredevops_project" "curtain_wall" {
  name = var.azdo_project_name
}

#
# remote tfstate storage
#
resource "azurerm_storage_account" "tfstate" {
  name                     = azurecaf_name.generated["tfstate_sa"].result
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = azurecaf_name.generated["tfstate_container"].result
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

#
# Variable Group
#
resource "azuredevops_variable_group" "infra_installer" {
  name         = var.azdo_variable_group_name
  project_id   = data.azuredevops_project.curtain_wall.id
  description  = "Variables for the create-infra-installer pipeline."
  allow_access = true

  variable {
    name  = "install_remote"
    value = true
  }

  variable {
    name  = "subscription_id"
    value = var.subscription_id
  }

  variable {
    name  = "azdo_project_name"
    value = var.azdo_project_name
  }

  variable {
    name  = "azdo_variable_group_name"
    value = var.azdo_variable_group_name
  }

  variable {
    name  = "azdo_service_connection"
    value = var.azdo_service_connection
  }

  variable {
    name  = "location"
    value = var.resource_group.location
  }

  variable {
    name  = "create_mi"
    value = var.create_mi
  }

  variable {
    name  = "create_vnet"
    value = var.create_vnet
  }

  variable {
    name  = "existing_vnet_name"
    value = var.existing_vnet_name
  }

  variable {
    name  = "new_vnet_address_space"
    value = var.new_vnet_address_space
  }

  variable {
    name  = "existing_vnet_rg_name"
    value = var.existing_vnet_rg_name
  }

  variable {
    name  = "existing_vnet_rg_location"
    value = var.existing_vnet_rg_location
  }

  variable {
    name  = "create_subnet"
    value = var.create_subnet
  }

  variable {
    name  = "new_subnet_address_prefixes"
    value = var.new_subnet_address_prefixes
  }

  variable {
    name  = "existing_subnet_id"
    value = var.existing_subnet_id
  }

  variable {
    name  = "create_bastion"
    value = var.create_bastion
  }

  variable {
    name  = "bastion_subnet_address_prefixes"
    value = var.bastion_subnet_address_prefixes
  }

  variable {
    name  = "count_of_agents"
    value = var.count_of_agents
  }

  variable {
    name  = "azdo_org_name"
    value = var.azdo_org_name
  }

  variable {
    name      = "azdo_pat"
    value     = var.azdo_pat
    is_secret = true
  }

  variable {
    name  = "azdo_agent_version"
    value = var.azdo_agent_version
  }

  variable {
    name  = "azdo_pool_name"
    value = var.azdo_pool_name
  }

  variable {
    name  = "azdo_build_agent_name"
    value = var.azdo_build_agent_name
  }

  variable {
    name  = "environment_demand_name"
    value = var.environment_demand_name
  }

  variable {
    name  = "state_resource_group_name"
    value = azurerm_storage_account.tfstate.resource_group_name
  }

  variable {
    name  = "state_storage_account_name"
    value = azurerm_storage_account.tfstate.name
  }

  variable {
    name  = "state_container_name"
    value = azurerm_storage_container.tfstate.name
  }

  variable {
    name  = "state_key"
    value = var.state_key
  }

}