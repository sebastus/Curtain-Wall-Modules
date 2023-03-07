module "myvhd" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//vhd-or-image?ref=main"
  #source = "../../Curtain-Wall-Modules/vhd-or-image"

  hcl_path_and_file_name = var.xxx_hcl_path_and_file_name

  arm_client_id     = var.xxx_arm_client_id
  arm_client_secret = var.xxx_arm_client_secret

  install_password = var.xxx_install_password
  local_temp       = var.xxx_local_temp

  vhd_or_image = var.xxx_vhd_or_image

  image_resource_group_name = var.xxx_image_resource_group_name
  image_base_name           = var.xxx_image_base_name

  vhd_capture_name_prefix = var.xxx_vhd_capture_name_prefix
  vhd_resource_group_name = var.xxx_vhd_resource_group_name
  vhd_storage_account     = var.xxx_vhd_storage_account

  # if using existing network
  vnet_name           = var.xxx_vnet_name
  vnet_resource_group = var.xxx_vnet_resource_group
  vnet_subnet         = var.xxx_vnet_subnet
}
