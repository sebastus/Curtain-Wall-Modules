#
# Key Vault
#
resource "azurerm_key_vault" "kv" {
  count = var.create_kv ? 1 : 0

  name                = azurecaf_name.generated["kv"].result
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_subscription.env.tenant_id
  sku_name            = "standard"

  public_network_access_enabled = !var.make_created_kv_private

  network_acls {
    bypass                     = "AzureServices"
    default_action             = var.make_created_kv_private ? "Deny" : "Allow"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Set",
      "List",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

data "azurerm_key_vault" "keyvault" {
  name                = var.create_kv ? azurerm_key_vault.kv[0].name : var.existing_kv_name
  resource_group_name = var.create_kv ? azurerm_key_vault.kv[0].resource_group_name : var.existing_kv_rg_name
}

resource "azurerm_private_dns_zone" "vault" {
  count = var.make_created_kv_private ? 1 : 0

  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  count = var.make_created_kv_private ? 1 : 0

  name                  = "keyvault-vnet-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.vault[0].name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "keyvault" {
  count = var.make_created_kv_private ? 1 : 0

  name                = azurecaf_name.generated["pe-kv"].result
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = var.keyvault_pe_subnet_id

  custom_network_interface_name = "${azurerm_key_vault.kv[0].name}-nic"

  private_service_connection {
    name                           = "private_kv_service_connection"
    private_connection_resource_id = data.azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault", ]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.vault[0].id]
  }
}