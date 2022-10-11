#################

output "state_rg_name" {
  value = azurerm_storage_account.tfstate.resource_group_name
}

output "state_storage_name" {
  value = azurerm_storage_container.tfstate.storage_account_name
}

output "state_container_name" {
  value = azurerm_storage_container.tfstate.name
}

output "state_key" {
  value = var.state_key
}

##############
