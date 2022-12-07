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
    aks = { resource_type = "azurerm_kubernetes_cluster" },
    subnet = { resource_type = "azurerm_subnet" },
  }
}

#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  resource_type = each.value.resource_type
  suffixes      = [var.instance_index]
}
