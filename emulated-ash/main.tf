#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = var.base_name
  resource_type = each.value.resource_type
  random_length = each.value.random_length
}

#
# managed identity
#  * will be installed in the ASH VM
#  * has these permissions:
#  *   Reader on resource group 
#
resource "azurerm_user_assigned_identity" "mi" {
  count               = var.create_managed_identity ? 1 : 0
  name                = azurecaf_name.generated["mi"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

# this ingests a previously provisioned UAMI 
data "azurerm_user_assigned_identity" "mi" {
  name                = var.create_managed_identity ? azurerm_user_assigned_identity.mi[0].name : var.existing_managed_identity_name
  resource_group_name = var.create_managed_identity ? var.resource_group.name : var.existing_managed_identity_rg
}

#
# role assignment: Reader
# scoped to the resource group
#
resource "azurerm_role_assignment" "rg_reader" {
  scope                = var.resource_group.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_user_assigned_identity.mi.principal_id
}

#
# key vault
# 
resource "azurerm_key_vault" "kv" {
  count               = var.create_key_vault ? 1 : 0
  name                = azurecaf_name.generated["kv"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tenant_id           = data.azurerm_subscription.env.tenant_id

  sku_name                        = "premium"
  soft_delete_retention_days      = 7
  enable_rbac_authorization       = true
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  public_network_access_enabled   = false

  network_acls {
    bypass = "None"
    default_action = "Deny"
    ip_rules = []
  }
}

# this ingests a previously provisioned kv
data "azurerm_key_vault" "kv" {
  name                = var.create_key_vault ? azurerm_key_vault.kv[0].name : var.existing_key_vault_name
  resource_group_name = var.create_key_vault ? var.resource_group.name : var.existing_key_vault_rg
}

#
# admin password secret
# this forces terraform to be run from within the network
#
resource "azurerm_key_vault_secret" "admin_password" {
  name         = "AdminPassword"
  value        = var.admin_password
  key_vault_id = data.azurerm_key_vault.kv.id
}

#
# role assignment: Key Vault Secrets User
# scoped to the kv
#
resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = data.azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_user_assigned_identity.mi.principal_id
}

#
# kv private endpoint
#
resource "azurerm_private_endpoint" "kv" {
  name                = "kv-private-endpoint"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "private_kv_service_connection"
    private_connection_resource_id = data.azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
  }

}

