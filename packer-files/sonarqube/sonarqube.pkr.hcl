#
# SonarQube 
#
variable "allowed_inbound_ip_addresses" {
  type    = list(string)
  default = []
}

variable "azure_tag" {
  type    = map(string)
  default = {}
}

variable "build_resource_group_name" {
  type    = string
  default = "${env("BUILD_RESOURCE_GROUP_NAME")}"
}

variable "temp_resource_group_name" {
  type    = string
  default = "${env("TEMP_RESOURCE_GROUP_NAME")}"
}

variable "tenant_id" {
  type    = string
  default = "${env("ARM_TENANT_ID")}"
}

variable "subscription_id" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

variable "client_id" {
  type    = string
  default = "${env("ARM_CLIENT_ID")}"
}

variable "client_secret" {
  type      = string
  default   = "${env("ARM_CLIENT_SECRET")}"
  sensitive = true
}

variable "vm_size" {
  type    = string
  default = "Standard_D4s_v4"
}

variable "private_virtual_network_with_public_ip" {
  type    = bool
  default = false
}

variable "virtual_network_name" {
  type    = string
  default = "${env("VNET_NAME")}"
}

variable "virtual_network_resource_group_name" {
  type    = string
  default = "${env("VNET_RESOURCE_GROUP")}"
}

variable "virtual_network_subnet_name" {
  type    = string
  default = "${env("VNET_SUBNET")}"
}

variable "vhd_or_image" {
  type    = string
  default = "${env("VHD_OR_IMAGE")}"

  validation {
    condition     = var.vhd_or_image == "vhd" || var.vhd_or_image == "image"
    error_message = "Input variable vhd_or_image must be either 'vhd' or 'image'."
  }
}

variable "managed_image_name" {
  type    = string
  default = "${env("ARM_MANAGED_IMAGE_NAME")}"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "${env("ARM_MANAGED_IMAGE_RG_NAME")}"
}

variable "capture_name_prefix" {
  type    = string
  default = "${env("VHD_CAPTURE_NAME_PREFIX")}"
}

variable "capture_container_name" {
  type    = string
  default = "${env("VHD_CAPTURE_CONTAINER_NAME")}"
}

variable "resource_group_name" {
  type    = string
  default = "${env("VHD_RESOURCE_GROUP_NAME")}"
}

variable "storage_account" {
  type    = string
  default = "${env("VHD_STORAGE_ACCOUNT")}"
}

source "azure-arm" "build_vhd" {

  # ingested resources
  allowed_inbound_ip_addresses = "${var.allowed_inbound_ip_addresses}"
  temp_resource_group_name     = "${var.temp_resource_group_name}"
  build_resource_group_name    = "${var.build_resource_group_name}"

  tenant_id        = "${var.tenant_id}"
  subscription_id  = "${var.subscription_id}"
  client_id        = "${var.client_id}"
  client_secret    = "${var.client_secret}"

  vm_size         = "${var.vm_size}"
  os_disk_size_gb = "86"

  image_offer     = "0001-com-ubuntu-server-focal"
  image_publisher = "canonical"
  image_sku       = "20_04-lts"
  location        = "${var.location}"
  os_type         = "Linux"

  private_virtual_network_with_public_ip = "${var.private_virtual_network_with_public_ip}"
  virtual_network_name                   = "${var.virtual_network_name}"
  virtual_network_resource_group_name    = "${var.virtual_network_resource_group_name}"
  virtual_network_subnet_name            = "${var.virtual_network_subnet_name}"

  managed_image_name                = var.vhd_or_image == "image" ? var.managed_image_name : ""
  managed_image_resource_group_name = var.vhd_or_image == "image" ? var.managed_image_resource_group_name : ""

  capture_container_name = var.vhd_or_image == "vhd" ? var.capture_container_name : ""
  capture_name_prefix    = var.vhd_or_image == "vhd" ? var.capture_name_prefix : ""
  resource_group_name    = var.vhd_or_image == "vhd" ? var.resource_group_name : ""
  storage_account        = var.vhd_or_image == "vhd" ? var.storage_account : ""

  dynamic "azure_tag" {
    for_each = var.azure_tag
    content {
      name  = azure_tag.key
      value = azure_tag.value
    }
  }
}
