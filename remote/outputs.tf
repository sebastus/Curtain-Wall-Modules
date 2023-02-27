#################

output "state_rg_name" {
  value = var.is_hub ? azurerm_storage_account.tfstate[0].resource_group_name : ""
}

output "state_storage_name" {
  value = var.is_hub ? azurerm_storage_container.tfstate[0].storage_account_name : ""
}

output "state_container_name" {
  value = var.is_hub ? azurerm_storage_container.tfstate[0].name : ""
}

output "state_key" {
  value = var.is_hub ? var.state_key : ""
}

##############
