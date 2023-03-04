module "aks_xxx" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//aks?ref=merge-from-cs"
  #source = "../../Curtain-Wall-Modules/aks"

  base_name = "aks-xxx"

  admin_username = var.xxx_aks_admin_username

  default_aks_pool_vm_sku = var.xxx_aks_default_aks_pool_vm_sku

  resource_group = module.rg_xxx.context_outputs.resource_group
  subnet_id      = module.rg_xxx.context_outputs.well_known_subnets["default"].id

  install_cert_manager = var.xxx_aks_install_cert_manager

  acr = module.rg_xxx.context_outputs.azurerm_container_registry
}
