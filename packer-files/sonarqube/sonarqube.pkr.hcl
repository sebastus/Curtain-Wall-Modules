#
# SonarQube 1
#
variable "location" {
  type    = string
  default = "${env("ARM_RESOURCE_LOCATION")}"
}

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

variable "managed_image_base_name" {
  type    = string
  default = "${env("ARM_MANAGED_IMAGE_BASE_NAME")}"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "${env("ARM_MANAGED_IMAGE_RG_NAME")}"
}

variable "image_publisher" {
  default = "canonical"
}
variable "image_offer" {
  default = "0001-com-ubuntu-server-focal"
}
variable "image_sku" {
  default = "20_04-lts"
}

locals  {
  capture_container_name = replace(lower("${var.image_publisher}-${var.image_offer}-${var.image_sku}"), "_", "-")
}

variable "capture_name_prefix" {
  type    = string
  default = "${env("VHD_CAPTURE_NAME_PREFIX")}"
}

variable "resource_group_name" {
  type    = string
  default = "${env("VHD_RESOURCE_GROUP_NAME")}"
}

variable "storage_account" {
  type    = string
  default = "${env("VHD_STORAGE_ACCOUNT")}"
}

variable "image_folder" {
  type    = string
  default = "/imagegeneration"
}

variable "installer_script_folder" {
  type    = string
  default = "/imagegeneration/installers"
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

  image_publisher = "${var.image_publisher}"
  image_offer     = "${var.image_offer}"
  image_sku       = "${var.image_sku}"
  location        = "${var.location}"
  os_type         = "Linux"

  ssh_username    = "adminaz"

  private_virtual_network_with_public_ip = "${var.private_virtual_network_with_public_ip}"
  virtual_network_name                   = "${var.virtual_network_name}"
  virtual_network_resource_group_name    = "${var.virtual_network_resource_group_name}"
  virtual_network_subnet_name            = "${var.virtual_network_subnet_name}"

  azure_tags = {
    "image_publisher": "${var.image_publisher}",
    "image_offer": "${var.image_offer}",
    "image_sku": "${var.image_sku}"
  }

  managed_image_name                = var.vhd_or_image == "image" ? var.managed_image_base_name : ""
  managed_image_resource_group_name = var.vhd_or_image == "image" ? var.managed_image_resource_group_name : ""

  capture_container_name = var.vhd_or_image == "vhd" ? local.capture_container_name : ""
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

build {
  sources = ["source.azure-arm.build_vhd"]

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "mkdir ${var.image_folder}",
      "chmod 777 ${var.image_folder}",
    ]
  }

  provisioner "file" {
    destination = "${var.installer_script_folder}"
    source      = "${path.root}/scripts/installers"
  }

  provisioner "shell" {
    environment_vars = ["INSTALLER_SCRIPT_FOLDER=${var.installer_script_folder}", "DEBIAN_FRONTEND=noninteractive"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = [
      "${path.root}/scripts/installers/docker_ce.sh",
      "${path.root}/scripts/installers/sonarqube/sonarqube.sh"
    ]
  }

provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "echo Generalizing the image.",
      "sleep 60",
    "/usr/sbin/waagent -force -deprovision && export HISTSIZE=0 && sync"]
  }

}