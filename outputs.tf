output "resource_group" {
  value = data.azurerm_resource_group.rg
}

output "vnet_name" {
  value = var.create_vnet ? azurerm_virtual_network.vnet[0].name : var.existing_vnet_name
}

output "managed_identity" {
  value = var.create_managed_identity ? azurerm_user_assigned_identity.mi[0] : null
}

output "subnet_id" {
  value = var.create_subnet ? azurerm_subnet.subnet[0].id : var.existing_subnet_id
}

output "law_id" {
  value = var.create_law ? azurerm_log_analytics_workspace.law[0].workspace_id : ""
}

output "law_key" {
  value = var.create_law ? azurerm_log_analytics_workspace.law[0].primary_shared_key : ""
}

output "acr_id" {
  value = var.create_acr ? azurerm_container_registry.acr[0].id : ""
}