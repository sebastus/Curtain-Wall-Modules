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
    nic = { resource_type = "azurerm_network_interface", base_name = "build-agent" },
    vm  = { resource_type = "azurerm_linux_virtual_machine", base_name = "build-agent" },
  }
}

#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = each.value.base_name
  resource_type = each.value.resource_type
  suffixes      = [var.instance_index]
}
