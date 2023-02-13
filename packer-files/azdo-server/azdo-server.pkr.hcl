variable "location" {
  type    = string
  default = "${env("ARM_RESOURCE_LOCATION")}"
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
  type    = string
  default = "${env("ARM_CLIENT_SECRET")}"
}

variable "virtual_network_name" {
  type    = string
  default = "${env("ARM_VIRTUAL_NETWORK_NAME")}"
}

variable "virtual_network_resource_group_name" {
  type    = string
  default = "${env("ARM_VIRTUAL_NETWORK_RESOURCE_GROUP_NAME")}"
}

variable "virtual_network_subnet_name" {
  type    = string
  default = "${env("ARM_VIRTUAL_NETWORK_SUBNET_NAME")}"
}

variable "vhd_or_image" {
  type    = string
  default = "${env("VHD_OR_IMAGE")}"

  validation {
    condition     = var.vhd_or_image == "vhd" || var.vhd_or_image == "image"
    error_message = "Input variable vhd_or_image must be either 'vhd' or 'image'."
  }
}

variable "capture_container_name" {
  type    = string
  default = "${env("VHD_CAPTURE_CONTAINER_NAME")}"
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

variable "managed_image_resource_group_name" {
  type    = string
  default = "${env("ARM_MANAGED_IMAGE_RG_NAME")}"
}

variable "managed_image_name" {
  type    = string
  default = "${env("ARM_MANAGED_IMAGE_NAME")}"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2_v4"
}

variable "install_user" {
  type    = string
  default = "installer"
}

variable "install_password" {
  type    = string
  default = "${env("INSTALL_PASSWORD")}"
}

source "azure-arm" "build_vhd" {

  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  vm_size         = var.vm_size
  os_disk_size_gb = "256"

  # the "azure-edition" versions of 2022 don't support vhd
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2022-datacenter"
  location        = "${var.location}"
  os_type         = "Windows"

  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_subnet_name         = var.virtual_network_subnet_name

  communicator   = "winrm"
  winrm_use_ssl  = "true"
  winrm_insecure = "true"
  winrm_username = "packer"

  managed_image_name                = var.vhd_or_image == "image" ? var.managed_image_name : ""
  managed_image_resource_group_name = var.vhd_or_image == "image" ? var.managed_image_resource_group_name : ""

  capture_container_name = var.vhd_or_image == "vhd" ? var.capture_container_name : ""
  capture_name_prefix    = var.vhd_or_image == "vhd" ? var.capture_name_prefix : ""
  resource_group_name    = var.vhd_or_image == "vhd" ? var.resource_group_name : ""
  storage_account        = var.vhd_or_image == "vhd" ? var.storage_account : ""

}

build {
  sources = ["source.azure-arm.build_vhd"]

  provisioner "windows-shell" {
    inline = [
      "net user ${var.install_user} ${var.install_password} /add /passwordchg:no /passwordreq:yes /active:yes /Y",
      "net localgroup Administrators ${var.install_user} /add",
      "winrm set winrm/config/service/auth @{Basic=\"true\"}",
      "winrm get winrm/config/service/auth"
    ]
  }

  provisioner "powershell" {
    inline = [
      "if (-not ((net localgroup Administrators) -contains '${var.install_user}')) { exit 1 }"
    ]
  }

  provisioner "powershell" {
    inline = [
      "bcdedit.exe /set TESTSIGNING ON"
    ]
    elevated_user     = var.install_user
    elevated_password = var.install_password
  }

  provisioner "powershell" {
    inline = [
      "Write-Host \"Download the AzDO Server installer\"",
      "$url = \"https://go.microsoft.com/fwlink/?LinkId=2200892\" ",
      "$output = \"c:\\users\\${var.install_user}\\Downloads\\azdo_server_installer.exe\"",
      "$wc = New-Object System.Net.WebClient",
      "$wc.DownloadFile($url, $output)"
    ]
    elevated_user     = var.install_user
    elevated_password = var.install_password
  }

  provisioner "powershell" {
    inline = [
      "Write-Host \"Confirm download of the AzDO Server installer\"",
      "dir c:\\users\\${var.install_user}\\Downloads"
    ]
  }

  provisioner "powershell" {
    inline = [
      "Write-Host \"Execute the AzDO Server installer\"",
      "c:\\users\\${var.install_user}\\Downloads\\azdo_server_installer.exe /q /full"
    ]
  }

  provisioner "windows-restart" {
    restart_timeout = "10m"
  }

  provisioner "powershell" {
    inline = [
      "if( Test-Path $Env:SystemRoot\\System32\\Sysprep\\unattend.xml ){ rm $Env:SystemRoot\\System32\\Sysprep\\unattend.xml -Force}",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /mode:vm /quiet /quit",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}

