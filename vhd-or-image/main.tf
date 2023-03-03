#
# Get the packer definition 
# This is the absolute path and file name of the HCL file.
# 
data "packer_files" "hcl" {
  file = var.hcl_path_and_file_name
}

#
# get the resource group where the vhd or image will go
# packer resources must be in the same region
#
data "azurerm_resource_group" "rg_artefact" {
  name = var.vhd_or_image == "vhd" ? var.vhd_resource_group_name : var.image_resource_group_name
}

#
# Generate the vhd or managed image using packer
#
resource "packer_image" "artefact" {
  file  = data.packer_files.hcl.file
  force = true

  environment = {
    ARM_RESOURCE_LOCATION = data.azurerm_resource_group.rg_artefact.location

    VHD_OR_IMAGE = var.vhd_or_image
    # if vhd
    VHD_CAPTURE_NAME_PREFIX = var.vhd_capture_name_prefix
    VHD_RESOURCE_GROUP_NAME = var.vhd_resource_group_name
    VHD_STORAGE_ACCOUNT     = var.vhd_storage_account
    # else if image
    ARM_MANAGED_IMAGE_RG_NAME   = var.image_resource_group_name
    ARM_MANAGED_IMAGE_BASE_NAME = var.image_base_name
    # end

    # if using existing network
    VNET_NAME           = var.vnet_name
    VNET_RESOURCE_GROUP = var.vnet_resource_group
    VNET_SUBNET         = var.vnet_subnet
    # end

    ARM_USE_INTERACTIVE_AUTH = false
    ARM_TENANT_ID            = data.azurerm_subscription.env.tenant_id
    ARM_SUBSCRIPTION_ID      = data.azurerm_subscription.env.subscription_id
    ARM_CLIENT_ID            = var.arm_client_id
    ARM_CLIENT_SECRET        = var.arm_client_secret
    INSTALL_PASSWORD         = var.install_password
    TMP                      = var.local_temp
  }

  ignore_environment = true

  triggers = {
    files_hash = data.packer_files.hcl.files_hash
  }
}

