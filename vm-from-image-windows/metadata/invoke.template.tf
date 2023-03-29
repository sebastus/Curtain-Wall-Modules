module "my-windows-vm" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//vm-from-image-windows?ref=main"
  #source = "../../cs/Curtain-Wall-Modules/vm-from-image-windows"

  base_name      = "windows_vm"
  admin_password = var.xxx_vfiw_admin_password

  resource_group = module.tg_xxx.resource_group
  identity_ids = [
    module.tg_xxx.managed_identity == null ? null : module.tg_xxx.managed_identity.id
  ]
  subnet_id = module.tg_xxx.well_known_subnets["default"].id

  key_vault = module.tg_xxx.azurerm_key_vault
  
  # optionally install public ip
  create_pip = var.xxx_vfiw_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_vfiw_install_omsagent

  log_analytics_workspace_id  = module.tg_xxx.log_analytics_workspace == null ? null : module.tg_xxx.log_analytics_workspace.workspace_id
  log_analytics_workspace_key = module.tg_xxx.log_analytics_workspace == null ? null : module.tg_xxx.log_analytics_workspace.primary_shared_key

  image_resource_group_name = var.xxx_vfiw_image_resource_group_name
  image_base_name           = var.xxx_vfiw_image_base_name

  # correct this for your configuration so the vm
  # depends on the right image 
  depends_on = [
    module.vhd-or-image
  ]
}
