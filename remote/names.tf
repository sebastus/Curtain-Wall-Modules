#
# Names to be generated
#
variable "singleton_resource_names" {
  type = map(object(
    {
      resource_type = string,
      base_name     = string,
      random_length = number
    }
  ))

  default = {
    tfstate_sa        = { resource_type = "azurerm_storage_account", base_name = "tf", random_length = 4 },
    tfstate_container = { resource_type = "azurerm_storage_container", base_name = "tfstate", random_length = 0 },
  }
}

#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = each.value.base_name
  resource_type = each.value.resource_type
  random_length = each.value.random_length
}
