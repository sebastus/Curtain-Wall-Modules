module "my-windows-vm" {
  #source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//vm-from-image-windows"
  source = "../../cs/Curtain-Wall-Modules/vm-from-image-windows"

  base_name      = "azdo_server"
  admin_password = var.xxx_vfiw_admin_password

  resource_group = module.rg_xxx.resource_group
  identity_ids   = [
    module.rg_xxx.managed_identity == null ? null : module.rg_xxx.managed_identity.id
  ]
  subnet_id      = module.rg_xxx.subnet_id

  # optionally install public ip
  create_pip = var.xxx_vfiw_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_vfiw_install_omsagent

  log_analytics_workspace_id = module.rg_xxx.law_id
  log_analytics_workspace_key = module.rg_xxx.law_key

  image_resource_group_name = var.xxx_vfiw_image_resource_group_name
  image_base_name           = var.xxx_vfiw_image_base_name

}
