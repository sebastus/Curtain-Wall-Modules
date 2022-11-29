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
    cg = { resource_type = "azurerm_container_group", base_name = "ba" },
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
