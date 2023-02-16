module "my-linux-vm" {
  #source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//vm-from-image-linux"
  source = "../../cs/Curtain-Wall-Modules/vm-from-image-linux"

  base_name      = "my_vm"

  resource_group = module.rg_hub.resource_group
  identity_ids   = [
    module.rg_hub.managed_identity == null ? null : module.rg_hub.managed_identity.id
  ]
  subnet_id      = module.rg_hub.subnet_id

  # optionally install public ip
  create_pip = var.xxx_vfil_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_vfil_install_omsagent

  log_analytics_workspace_id = module.rg_hub.law_id
  log_analytics_workspace_key = module.rg_hub.law_key

  image_resource_group_name = var.xxx_vfil_image_resource_group_name
  image_base_name           = var.xxx_vfil_image_base_name

}
