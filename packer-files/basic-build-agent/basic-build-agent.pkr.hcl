# Test Comment 1
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

variable "vhd_or_image" {
  type    = string
  default = "${env("VHD_OR_IMAGE")}"

  validation {
    condition     = var.vhd_or_image == "vhd" || var.vhd_or_image == "image"
    error_message = "Input variable vhd_or_image must be either 'vhd' or 'image'."
  }
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

variable "client_id" {
  type    = string
  default = "${env("ARM_CLIENT_ID")}"
}

variable "client_secret" {
  type      = string
  default   = "${env("ARM_CLIENT_SECRET")}"
  sensitive = true
}

variable "client_cert_path" {
  type    = string
  default = "${env("ARM_CLIENT_CERT_PATH")}"
}

variable "commit_url" {
  type    = string
  default = ""
}

variable "dockerhub_login" {
  type    = string
  default = "${env("DOCKERHUB_LOGIN")}"
}

variable "dockerhub_password" {
  type    = string
  default = "${env("DOCKERHUB_PASSWORD")}"
}

variable "helper_script_folder" {
  type    = string
  default = "/imagegeneration/helpers"
}

variable "image_folder" {
  type    = string
  default = "/imagegeneration"
}

variable "image_os" {
  type    = string
  default = "ubuntu20"
}

variable "image_version" {
  type    = string
  default = "dev"
}

variable "imagedata_file" {
  type    = string
  default = "/imagegeneration/imagedata.json"
}

variable "installer_script_folder" {
  type    = string
  default = "/imagegeneration/installers"
}

variable "install_password" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = "${env("ARM_RESOURCE_LOCATION")}"
}

variable "managed_image_base_name" {
  type    = string
  default = "${env("ARM_MANAGED_IMAGE_BASE_NAME")}"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "${env("ARM_MANAGED_IMAGE_RG_NAME")}"
}

variable "private_virtual_network_with_public_ip" {
  type    = bool
  default = false
}

variable "resource_group" {
  type    = string
  default = "${env("ARM_RESOURCE_GROUP")}"
}

variable "run_validation_diskspace" {
  type    = bool
  default = false
}

variable "subscription_id" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

variable "temp_resource_group_name" {
  type    = string
  default = "${env("TEMP_RESOURCE_GROUP_NAME")}"
}

variable "tenant_id" {
  type    = string
  default = "${env("ARM_TENANT_ID")}"
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

variable "vm_size" {
  type    = string
  default = "Standard_D4s_v4"
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
  client_cert_path = "${var.client_cert_path}"

  vm_size         = "${var.vm_size}"
  os_disk_size_gb = "86"

  image_publisher = "${var.image_publisher}"
  image_offer     = "${var.image_offer}"
  image_sku       = "${var.image_sku}"
  location        = "${var.location}"
  os_type         = "Linux"

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

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "${path.root}/scripts/base/apt-mock.sh"
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = ["${path.root}/scripts/base/repos.sh"]
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    script           = "${path.root}/scripts/base/apt.sh"
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "${path.root}/scripts/base/limits.sh"
  }

  provisioner "file" {
    destination = "${var.helper_script_folder}"
    source      = "${path.root}/scripts/helpers"
  }

  provisioner "file" {
    destination = "${var.installer_script_folder}"
    source      = "${path.root}/scripts/installers"
  }

  provisioner "file" {
    destination = "${var.image_folder}"
    source      = "${path.root}/scripts/tests"
  }

  # Among other things, the toolset db has a list of powershell modules needed for testing.
  provisioner "file" {
    destination = "${var.installer_script_folder}/toolset.json"
    source      = "${path.root}/toolsets/toolset-2004.json"
  }

  provisioner "shell" {
    environment_vars = ["IMAGE_VERSION=${var.image_version}", "IMAGE_OS=${var.image_os}", "HELPER_SCRIPTS=${var.helper_script_folder}"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = ["${path.root}/scripts/installers/configure-environment.sh"]
  }

  # the test infrastructure is based on Pester tests. This requires powershell. 
  provisioner "shell" {
    environment_vars = ["HELPER_SCRIPTS=${var.helper_script_folder}"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = ["${path.root}/scripts/installers/complete-snap-setup.sh", "${path.root}/scripts/installers/powershellcore.sh"]
  }

  # Required by the testing system.
  provisioner "shell" {
    environment_vars = ["HELPER_SCRIPTS=${var.helper_script_folder}", "INSTALLER_SCRIPT_FOLDER=${var.installer_script_folder}"]
    execute_command  = "sudo sh -c '{{ .Vars }} pwsh -f {{ .Path }}'"
    scripts          = ["${path.root}/scripts/installers/Install-PowerShellModules.ps1", "${path.root}/scripts/installers/Install-AzureModules.ps1"]
  }

  provisioner "shell" {
    environment_vars = ["HELPER_SCRIPTS=${var.helper_script_folder}", "INSTALLER_SCRIPT_FOLDER=${var.installer_script_folder}", "DEBIAN_FRONTEND=noninteractive"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts = [
      "${path.root}/scripts/installers/basic.sh",
      "${path.root}/scripts/installers/azure-cli.sh",
      "${path.root}/scripts/installers/azure-devops-cli.sh",
      "${path.root}/scripts/installers/packer.sh",
      "${path.root}/scripts/installers/terraform.sh",
    ]
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "${path.root}/scripts/base/snap.sh"
  }

  provisioner "shell" {
    execute_command   = "/bin/sh -c '{{ .Vars }} {{ .Path }}'"
    expect_disconnect = true
    scripts           = ["${path.root}/scripts/base/reboot.sh"]
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "${path.root}/scripts/base/apt-mock-remove.sh"
    pause_before    = "180s"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "${path.root}/config/ubuntu2004.conf"
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "echo Configuring vsts",
      "mkdir -p /etc/vsts",
    "cp /tmp/ubuntu2004.conf /etc/vsts/machine_instance.conf"]
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "echo Generalizing the image.",
      "sleep 60",
    "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    skip_clean = true
  }

}