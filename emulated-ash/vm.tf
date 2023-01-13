#
# nic
#
resource "azurerm_network_interface" "windows_vm" {
  name                = azurecaf_name.generated["nic"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_image" "asdk" {
  name                = azurecaf_name.generated["asdk"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  os_disk {
    os_type  = "Windows"
    os_state = "Generalized"
    blob_uri = var.asdk_vhd_source_uri
    size_gb  = 512
  }
}

resource "azurerm_windows_virtual_machine" "vm" {

  name                  = azurecaf_name.generated["vm"].result
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.windows_vm.id]
  size                  = "Standard_E32ds_v5"
  computer_name         = "emulated-ash"

  # This creates an account, but doesn't assign a password to it.
  admin_username = "adminbs"

  # this sets the password of the built-in "Administrator" account
  admin_password = var.admin_password

  custom_data = filebase64("${path.module}/PowerShell/psnuget.zip")

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.mi.id]
  }

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 512
  }

  source_image_id = azurerm_image.asdk.id

}

resource "azurerm_managed_disk" "data_disks" {
  count = 4

  name                 = "emulated-ash-disk-${count.index}"
  location             = var.resource_group.location
  resource_group_name  = var.resource_group.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 256
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disks" {
  count = 4

  managed_disk_id    = azurerm_managed_disk.data_disks[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = count.index
  caching            = "ReadWrite"
}

locals { # cse = custom script extension
  cse_cmdToExecute = file("${path.module}/StartUpScript.ps1")

  cse_protected_settings = jsonencode({
    commandToExecute = "powershell -c ${local.cse_cmdToExecute}"
  })
}

resource "azurerm_virtual_machine_extension" "start_pwsh" {

  name                 = "start-pwsh"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = local.cse_protected_settings

}

locals {
  amw_settings = jsonencode(
    {
      AntimalwareEnabled : true
      RealtimeProtectionEnabled : true
      ScheduledScanSettings : {
        isEnabled : false
        day : 7
        time : 120
        scanType : "Quick"
      }
      Exclusions : {
        Extensions : ""
        Paths : ""
        Processes : ""
      }
    }
  )
}

resource "azurerm_virtual_machine_extension" "anti_malware" {

  name                 = "antimalware"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.6"

  settings = local.amw_settings
}

resource "azurerm_virtual_machine_extension" "azure_policy" {

  name                       = "AzurePolicyForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationForWindows"
  type_handler_version       = "1.29"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  settings                   = jsonencode({})
}
