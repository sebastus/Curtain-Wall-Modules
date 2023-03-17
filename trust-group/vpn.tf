#
# AAD configuration for VPN server
#
resource "azurerm_vpn_server_configuration" "platform_vpn" {
  count = var.create_platform_vpn ? 1 : 0

  name                       = "platform_vpn_config"
    resource_group_name      = data.azurerm_resource_group.rg.name
    location                 = data.azurerm_resource_group.rg.location

    vpn_authentication_types = ["AAD"]

    azure_active_directory_authentication {
      audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
      issuer = "https://sts.windows.net/16b3c013-d300-468d-ac64-7eda0820b6d3/"
      tenant = "https://login.microsoftonline.com/16b3c013-d300-468d-ac64-7eda0820b6d3"
    }
}

resource "azurerm_virtual_wan" "platform_vpn" {
  count = var.create_platform_vpn ? 1 : 0
  
  name                = azurecaf_name.generated["virtual_wan"].result

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}

resource "azurerm_virtual_hub" "platform_vpn" {
  count = var.create_platform_vpn ? 1 : 0
  
  name                = azurecaf_name.generated["virtual_hub"].result

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  virtual_wan_id      = azurerm_virtual_wan.platform_vpn[0].id
  address_prefix      = "10.1.200.0/23"
}

resource "azurerm_point_to_site_vpn_gateway" "platform_vpn" {
  count = var.create_platform_vpn ? 1 : 0
  
  name                = azurecaf_name.generated["p2s_vpn"].result

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  virtual_hub_id              = azurerm_virtual_hub.platform_vpn[0].id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.platform_vpn[0].id

  scale_unit                  = 1
  connection_configuration {
    name = "platform_vpn-gateway-config"

    vpn_client_address_pool {
      address_prefixes = [
        "10.1.202.0/24"
      ]
    }
  }
}