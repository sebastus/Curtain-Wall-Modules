module "aks_xxx" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//aks?ref=main"
  #source = "../../Curtain-Wall-Modules/aks"

  base_name = "aks-xxx"

  admin_username = var.xxx_aks_admin_username

  default_aks_pool_vm_sku = var.xxx_aks_default_aks_pool_vm_sku

  resource_group = module.tg_xxx.resource_group
  subnet_id      = module.tg_xxx.well_known_subnets["default"].id

  install_cert_manager = var.xxx_aks_install_cert_manager

  acr = module.tg_xxx.azurerm_container_registry
}
