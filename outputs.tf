output "resource_group" {
  value = azurerm_resource_group.rg
}

output "vnet_name" {
  value = var.create_vnet ? azurerm_virtual_network.vnet[0].name : var.existing_vnet_name
}

output "mi_id" {
  value = azurerm_user_assigned_identity.mi[0].id
}

output "subnet_id" {
  value = var.create_subnet ? azurerm_subnet.subnet[0].id : var.existing_subnet_id
}