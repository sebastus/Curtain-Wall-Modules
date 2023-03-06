module "my-linux-vm" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//vm-from-image-linux?ref=merge-from-cs"
  #source = "../../cs/Curtain-Wall-Modules/vm-from-image-linux"

  base_name = "linux_vm"

  resource_group = module.rg_xxx.context_outputs.resource_group
  identity_ids = [
    module.rg_xxx.context_outputs.managed_identity == null ? null : module.rg_xxx.context_outputs.managed_identity.id
  ]
  subnet_id = module.rg_xxx.context_outputs.well_known_subnets["default"].id

  # optionally install public ip
  create_pip = var.xxx_vfil_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_vfil_install_omsagent

  log_analytics_workspace_id  = module.rg_xxx.context_outputs.log_analytics_workspace == null ? null : module.rg_xxx.context_outputs.log_analytics_workspace.workspace_id
  log_analytics_workspace_key = module.rg_xxx.context_outputs.log_analytics_workspace == null ? null : module.rg_xxx.context_outputs.log_analytics_workspace.primary_shared_key

  image_resource_group_name = var.xxx_vfil_image_resource_group_name
  image_base_name           = var.xxx_vfil_image_base_name

  # correct this for your configuration so the vm
  # depends on the right image 
  depends_on = [
    module.myvhd
  ]
}
