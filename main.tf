#
# Create the container group
#
resource "azurerm_container_group" "cg" {
  name                = azurecaf_name.generated["cg"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  ip_address_type     = "Public"
  dns_name_label      = var.container-dns-name
  os_type             = "Linux"

  container {
    name   = var.container-name
    image  = var.container-image
    cpu    = var.container-cpu
    memory = var.container-memory

    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}