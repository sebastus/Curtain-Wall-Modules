output "resource_group" {
  value = data.azurerm_resource_group.rg
}

output "vnet" {
  value = data.azurerm_virtual_network.vnet
}

output "managed_identity" {
  value = data.azurerm_user_assigned_identity.mi
}

output "log_analytics_workspace" {
  value = var.create_law ? azurerm_log_analytics_workspace.law[0] : null
}

output "azurerm_container_registry" {
  value = var.create_acr ? azurerm_container_registry.acr[0] : null
}

output "well_known_subnets" {
  value = data.azurerm_subnet.well_known_subnets
}