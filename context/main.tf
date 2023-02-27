#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = var.base_name
  resource_type = each.value.resource_type
}

#
# resource group
#
resource "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 1 : 0

  name     = azurecaf_name.generated["rg"].result
  location = var.location
}

data "azurerm_resource_group" "rg" {
  name = var.create_resource_group ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
}

#
# Log analytics workspace
#
resource "azurerm_log_analytics_workspace" "law" {
  count = var.create_law ? 1 : 0

  name                = azurecaf_name.generated["law"].result
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#
# Container registry
#
resource "azurerm_container_registry" "acr" {
  count = var.create_acr ? 1 : 0

  name                = azurecaf_name.generated["acr"].result
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
}

# data "azurerm_container_registry" "acr" {
#   name = var.create_resource_group ? azurerm_container_registry.acr[0].name : null
# }

#
# managed identity
#  * will be installed in the build agent VM
#  * has the permissions needed to deploy resources in the environment
#
resource "azurerm_user_assigned_identity" "mi" {
  count               = var.create_managed_identity ? 1 : 0
  name                = azurecaf_name.generated["mi"].result
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# this allows the build agent to create resources in the subscription
resource "azurerm_role_assignment" "contributor" {
  count                = var.create_managed_identity ? 1 : 0
  scope                = var.subscription_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mi[0].principal_id
}

# this ingests a previously provisioned UAMI 
data "azurerm_user_assigned_identity" "mi" {
  name = var.create_managed_identity ? azurerm_user_assigned_identity.mi[0].name : var.existing_managed_identity_name
  resource_group_name = var.create_resource_group ? data.azurerm_resource_group.rg.name : var.existing_resource_group_name
}
