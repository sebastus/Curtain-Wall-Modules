variable "location" {
  type    = string
  default = "${env("ARM_RESOURCE_LOCATION")}"
}

variable "storage_account" {
  type    = string
  default = "${env("ARM_STORAGE_ACCOUNT")}"
}

variable "subscription_id" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

#variable "client_id" {
#  default = "${env("ARM_CLIENT_ID")}"
#}

#variable "client_secret" {
#  default = "${env("ARM_CLIENT_SECRET")}"
#}

variable "tenant_id" {
  default = "${env("ARM_TENANT_ID")}"
}

variable "managed_image_name" {
  type    = string
  default = "azdo_server-abcd"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = ${env("MANAGED_IMAGE_RG_NAME")}
}

variable "vm_size" {
  default = "Standard_D4ds_v5"
}

variable "install_user" {
  default = "installer"
}

variable "install_password" {
  default = "${env("INSTALLER_PASSWORD")}"
}

source "azure-arm" "build_vhd" {

  #client_id       = var.client_id
  #client_secret   = var.client_secret

  use_interactive_auth = true
  subscription_id      = var.subscription_id

  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2022-datacenter-azure-edition"
  location        = "${var.location}"
  os_type         = "Windows"
  vm_size         = var.vm_size
  os_disk_size_gb = "256"
  communicator    = "winrm"
  winrm_use_ssl   = "true"
  winrm_insecure  = "true"
  winrm_username  = "packer"

  managed_image_name                = var.managed_image_name
  managed_image_resource_group_name = var.managed_image_resource_group_name


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

