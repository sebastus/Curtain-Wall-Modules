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

