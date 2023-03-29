output "vm" {
  value     = azurerm_windows_virtual_machine.vm
  sensitive = true
}

output "admin_password" {
  value     = azurerm_key_vault_secret.password
  sensitive = true
}

output "packer_image" {
  value     = packer_image.azdo_server_image
  sensitive = true
}

output "subnet" {
  value = var.subnet
}