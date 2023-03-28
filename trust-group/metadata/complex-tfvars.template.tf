# List of well known subnets with configuration
# Expressed as map of object
xxx_well_known_subnets = {
  default = {
    address_prefix = "10.0.0.0/24"
  },
  AzureBastionSubnet = {
    address_prefix = "10.0.1.0/24"
  },
  PrivateEndpointsSubnet = {
    address_prefix = "10.0.2.0/24"
  }
}

# List of required private DNS zones
xxx_private_dns_zones = {
  keyvault = {
    domain = "privatelink.vaultcore.azure.net"
  },
  blob_storage = {
    domain = "privatelink.blob.core.windows.net"
  },
  acr = {
    domain = "privatelink.azurecr.io"
  },
  acr_uksouth = {
    domain = "uksouth.privatelink.azurecr.io"
  }
}