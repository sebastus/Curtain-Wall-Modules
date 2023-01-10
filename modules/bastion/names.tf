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
    bastion_pip = { resource_type = "azurerm_public_ip", base_name = "bastion" },
    bastion_nsg = { resource_type = "azurerm_network_security_group", base_name = "bastion-subnet" },
    bastion     = { resource_type = "azurerm_bastion_host", base_name = "bastion" },
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
