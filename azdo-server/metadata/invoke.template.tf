module "azdo-server" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//azdo-server?ref=main"
  #source = "../../cs/Curtain-Wall-Modules/azdo-server"

  base_name      = "azdo_server"
  admin_password = var.xxx_admin_password

  # optionally create the vm (might want only the vm image)
  create_vm = var.xxx_create_vm

  resource_group = module.tg_xxx.resource_group
  identity_ids = [
    module.tg_xxx.managed_identity == null ? null : module.tg_xxx.managed_identity.id
  ]
  subnet = module.tg_xxx.well_known_subnets[var.xxx_azdo_subnet_name]

  # optionally install public ip
  create_pip = var.xxx_create_pip

  key_vault = module.tg_xxx.azurerm_key_vault

  law_installed    = module.tg_xxx.create_law
  install_omsagent = var.xxx_install_omsagent

  log_analytics_workspace_id  = module.tg_xxx.create_law ? module.tg_xxx.log_analytics_workspace.workspace_id : null
  log_analytics_workspace_key = module.tg_xxx.create_law ? module.tg_xxx.log_analytics_workspace.primary_shared_key : null

  vhd_or_image = var.xxx_vhd_or_image

  vhd_capture_container_name = var.xxx_vhd_capture_container_name
  vhd_capture_name_prefix    = var.xxx_vhd_capture_name_prefix
  vhd_resource_group_name    = var.xxx_vhd_resource_group_name
  vhd_storage_account        = var.xxx_vhd_storage_account

  image_resource_group_name = var.xxx_image_resource_group_name
  image_base_name           = var.xxx_image_base_name

  arm_client_id          = var.xxx_arm_client_id
  arm_client_secret      = var.xxx_arm_client_secret
  arm_installer_password = var.xxx_arm_installer_password

  pkr_vnet_rg_name = var.xxx_vnet_rg_name
  pkr_vnet_name    = var.xxx_vnet_name
  pkr_subnet_name  = var.xxx_subnet_name

  local_temp = var.xxx_local_temp

}