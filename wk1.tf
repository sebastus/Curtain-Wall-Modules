module "rg_wk1" {
  source = "../cw-module-resource-group"

  install_remote = false
  is_hub         = false
  base_name      = "wk1"

  location = "eastus"

  create_resource_group        = var.wk1_create_resource_group
  existing_resource_group_name = var.wk1_existing_resource_group_name

  create_managed_identity = var.wk1_create_managed_identity
  subscription_id         = data.azurerm_subscription.env.id

  create_vnet            = var.wk1_create_vnet
  new_vnet_address_space = var.wk1_new_vnet_address_space
  existing_vnet_rg_name  = var.wk1_existing_vnet_rg_name
  existing_vnet_name     = var.wk1_existing_vnet_name

  create_subnet               = var.wk1_create_subnet
  existing_subnet_id          = var.wk1_existing_subnet_id
  new_subnet_address_prefixes = var.wk1_new_subnet_address_prefixes

  create_law = var.wk1_create_law
  create_acr = var.wk1_create_acr
}

module "p1bb-aks" {
  source = "../cw-module-p1bb-aks"

  count = var.wk1_create_p1bb ? 1 : 0

  resource_group   = module.rg_wk1.resource_group
  managed_identity = module.rg_wk1.managed_identity
  dns_prefix       = var.wk1_p1bb_aks_dns_prefix
  admin_username   = var.wk1_p1bb_admin_username
  vnet_name        = module.rg_wk1.vnet_name
  vnet_rg_name     = module.rg_wk1.resource_group.name
}