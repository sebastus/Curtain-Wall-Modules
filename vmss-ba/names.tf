#
# Names to be generated
#
variable "singleton_resource_names" {
  type = map(object(
    {
      resource_type = string
    }
  ))

  default = {
    vmss = { resource_type = "azurerm_virtual_machine_scale_set" },
  }
}

#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = var.base_name
  resource_type = each.value.resource_type
  suffixes      = [var.instance_index]
}
