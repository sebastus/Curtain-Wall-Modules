#
# Names to be generated
#
variable "singleton_resource_names" {
  type = map(object(
    {
      resource_type = string,
      base_name     = string
    }
  ))

  default = {
    rg     = { resource_type = "azurerm_resource_group", base_name = "curtainwall" },
    mi     = { resource_type = "azurerm_user_assigned_identity", base_name = "curtainwall" },
    vnet   = { resource_type = "azurerm_virtual_network", base_name = "curtainwall" },
    subnet = { resource_type = "azurerm_subnet", base_name = "curtainwall" },
    law    = { resource_type = "azurerm_log_analytics_workspace", base_name = "curtainwall" },
    acr    = { resource_type = "azurerm_container_registry", base_name = "curtainwall" },
  }
}

#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = each.value.base_name
  resource_type = each.value.resource_type
}
