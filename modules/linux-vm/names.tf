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
    pip = { resource_type = "azurerm_public_ip" },
    nic = { resource_type = "azurerm_network_interface" },
    vm  = { resource_type = "azurerm_linux_virtual_machine" },
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
