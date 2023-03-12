output "resource_group" {
  value = data.azurerm_resource_group.rg
}

output "env" {
  value     = data.azurerm_subscription.env
  sensitive = true
}

output "vnet" {
  value = data.azurerm_virtual_network.vnet
}

output "managed_identity" {
  value = data.azurerm_user_assigned_identity.mi
}

output "log_analytics_workspace" {
  value     = var.create_law ? azurerm_log_analytics_workspace.law[0] : null
  sensitive = true
}

output "azurerm_container_registry" {
  value = var.create_acr ? azurerm_container_registry.acr[0] : null
}

output "azurerm_key_vault" {
  value     = data.azurerm_key_vault.keyvault
  sensitive = true
}

output "well_known_subnets" {
  value = data.azurerm_subnet.well_known_subnets
}

#################

output "state_rg_name" {
  value = var.is_tfstate_home ? azurerm_storage_account.tfstate[0].resource_group_name : ""
}

output "state_storage_name" {
  value = var.is_tfstate_home ? azurerm_storage_container.tfstate[0].storage_account_name : ""
}

output "state_container_name" {
  value = var.is_tfstate_home ? azurerm_storage_container.tfstate[0].name : ""
}

output "state_key" {
  value = var.is_tfstate_home ? var.tfstate_storage_key : ""
}

##############
