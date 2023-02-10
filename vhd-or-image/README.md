# Introduction

# Invocation samples

## Invocation code in parent
```terraform
# ########################
# xxx - VHD-OR-IMAGE
# ########################
module "vhd" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//vhd-or-image?ref=golive"
  #source = "../../Curtain-Wall-Modules/vhd-or-image"

  hcl_path_and_file_name = var.xxx_azdo_hcl_path_and_file_name

  arm_client_id     = var.xxx_arm_client_id
  arm_client_secret = var.xxx_arm_client_secret

  install_password = var.xxx_install_password
  local_temp             = var.xxx_local_temp

  vhd_or_image = var.xxx_vhd_or_image

  image_resource_group_name = var.xxx_image_resource_group_name
  image_base_name           = var.xxx_image_base_name

  vhd_capture_container_name = var.xxx_vhd_capture_container_name
  vhd_capture_name_prefix = var.xxx_vhd_capture_name_prefix
  vhd_resource_group_name = var.xxx_vhd_resource_group_name
  vhd_storage_account = var.xxx_vhd_storage_account
}
```

## variables in parent
```terraform
# ########################
# xxx - VHD-OR-IMAGE
# ########################
variable "xxx_hcl_path_and_file_name" {
  description = "Relative (to main.tf) or fully qualified path and file name of hcl file."
    type = string
}
variable "xxx_arm_client_id" {
  description = "Credentials used by packer to create Azure resources"
  type = string
}
variable "xxx_arm_client_secret" {
  description = "Credentials used by packer to create Azure resources"
  type = string
}
variable "xxx_install_password" {
  description = "Password used in the Windows Packer vm during installation of software."
  type = string
}
variable "xxx_local_temp" {
  description = "The toowoxx/packer provider uses a temp folder on the system where Packer is being run."
  type = string
}

variable "xxx_vhd_or_image" {
    default = "image"
}

# if image
variable "xxx_image_base_name" {
    default = ""
}
variable "xxx_image_resource_group_name" {
    type = string
}
#elseif vhd
variable "xxx_vhd_resource_group_name" {
    type = string
}
variable "xxx_vhd_capture_container_name" {
  type = string
}
variable "xxx_vhd_capture_name_prefix" {
  type = string
}
variable "xxx_vhd_resource_group_name" {
  type = string
}
variable "xxx_vhd_storage_account" {
  type = string
}
# endif

```

## outputs
```terraform
# ########################
# xxx - VHD-OR-IMAGE
# ########################
```

## tfvars
```terraform
# ########################
# xxx - VHD-OR-IMAGE
# ########################
xxx_hcl_path_and_file_name = "../packer-files/azdo-server/azdo-server.pkr.hcl"

xxx_arm_client_id     = "guid"
xxx_arm_client_secret = "secret"

xxx_install_password = "R3all7L0ngP@ssw0rd!"
xxx_local_temp       = "%USERPROFILE%\\AppData\\Local\\Temp"

xxx_vhd_or_image = "image"

xxx_image_base_name           = "azdo-server"
xxx_image_resource_group_name = "rg-myManagedImages"

xxx_vhd_resource_group_name    = "rg-misc"
xxx_vhd_capture_container_name = "images"
xxx_vhd_capture_name_prefix    = "pkr"
xxx_vhd_storage_account        = "accountname"
```

