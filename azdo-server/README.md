# Introduction

# Invocation samples

## Invocation code in parent
```terraform
# ########################
# xxx - AzDO Server
# ########################
module "azdo-server" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//azdo-server"
  #source = "../../Curtain-Wall-Modules/azdo-server"

  base_name      = "azdo_server"
  admin_password = var.xxx_admin_password

  # optionally create the vm (might want only the vm image)
  create_vm = var.xxx_create_vm

  resource_group = module.rg_xxx.resource_group
  identity_ids   = [
    module.rg_xxx.managed_identity == null ? null : module.rg_xxx.managed_identity.id
  ]
  subnet_id      = module.rg_xxx.subnet_id

  # optionally install public ip
  create_pip = var.xxx_create_pip

  # optionally install oms agent
  install_omsagent = var.xxx_install_omsagent

  log_analytics_workspace_id = module.rg_xxx.law_id
  log_analytics_workspace_key = module.rg_xxx.law_key

  vhd_or_image = var.xxx_vhd_or_image

  vhd_capture_container_name = var.xxx_vhd_capture_container_name
  vhd_capture_name_prefix = var.xxx_vhd_capture_name_prefix
  vhd_resource_group_name = var.xxx_vhd_resource_group_name
  vhd_storage_account = var.xxx_vhd_storage_account

  image_resource_group_name = var.xxx_image_resource_group_name
  image_base_name           = var.xxx_image_base_name

  arm_client_id          = var.xxx_arm_client_id
  arm_client_secret      = var.xxx_arm_client_secret
  arm_installer_password = var.xxx_arm_installer_password

  vnet_name              = var.xxx_vnet_name
  vnet_rg_name           = var.xxx_vnet_rg_name
  subnet_name            = var.xxx_subnet_name

  local_temp             = var.xxx_local_temp

}
```

## variables in parent
```terraform
# ########################
# xxx - AzDO Server
# ########################
variable "xxx_create_vm" {
  default = true
}
variable "xxx_admin_password" {
    type = string
}
variable "xxx_create_pip" {
  default = false
}
variable "xxx_install_omsagent" {
  default = true
}


variable "xxx_vhd_or_image" {
  type    = string
  default = "image"
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

variable "xxx_image_resource_group_name" {
  type = string
}
variable "xxx_image_base_name" {
  type = string
}

variable "xxx_arm_client_id" {
  type = string
}
variable "xxx_arm_client_secret" {
  type = string
}

variable "xxx_arm_installer_password" {
  type = string
}

variable "xxx_vnet_name" {
  type =  string
}

variable "xxx_vnet_rg_name" {
  type =  string
}

variable "xxx_subnet_name" {
  type =  string
}

variable "xxx_local_temp" {
  type = string
}

```

## outputs
```terraform
# ########################
# xxx - AzDO Server
# ########################
```

## tfvars
```terraform
# ########################
# xxx - AzDO Server
# ########################

# relevant to the AzDO server
xxx_create_vm                  = true
xxx_install_omsagent           = true
xxx_admin_password             = "password"
xxx_create_pip                 = false

# relevant to packer operation
xxx_vhd_or_image               = "image"

xxx_vhd_capture_container_name = ""
xxx_vhd_capture_name_prefix    = ""
xxx_vhd_resource_group_name    = ""
xxx_vhd_storage_account        = ""

xxx_image_resource_group_name  = "rg-myManagedImages"
xxx_image_base_name            = "azdo_server"

xxx_arm_client_id              = "a-guid"
xxx_arm_client_secret          = "password"

xxx_arm_installer_password     = "password"

xxx_vnet_name                  = "vn_CRS_UKS_D"
xxx_vnet_rg_name               = "rg_CRS_UKS_D_Networking"
xxx_subnet_name                = "sub_CRS_UKS_D_Project"
xxx_local_temp                 = "c:\\users\\me\\AppData\\Local\\temp"
```

