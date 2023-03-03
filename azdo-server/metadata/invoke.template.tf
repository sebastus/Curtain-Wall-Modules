module "azdo-server" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//azdo-server"
  #source = "../../cs/Curtain-Wall-Modules/azdo-server"

  base_name      = "azdo_server"
  admin_password = var.xxx_admin_password

  # optionally create the vm (might want only the vm image)
  create_vm = var.xxx_create_vm

  resource_group = module.rg_xxx.context_outputs.resource_group
  identity_ids = [
    module.rg_xxx.context_outputs.managed_identity == null ? null : module.rg_xxx.context_outputs.managed_identity.id
  ]
  subnet_id = module.rg_xxx.context_outputs.well_known_subnets["default"].id

  # optionally install public ip
  create_pip = var.xxx_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_install_omsagent

  log_analytics_workspace_id  = module.rg_xxx.context_outputs.log_analytics_workspace == null ? null : module.rg_xxx.context_outputs.log_analytics_workspace.workspace_id
  log_analytics_workspace_key = module.rg_xxx.context_outputs.log_analytics_workspace == null ? null : module.rg_xxx.context_outputs.log_analytics_workspace.primary_shared_key

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

  local_temp = var.xxx_local_temp

}