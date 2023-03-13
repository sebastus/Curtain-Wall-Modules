output "private_key_openssh" {
  value     = tls_private_key.ssh.private_key_openssh
  sensitive = true
}

output "azurerm_image" {
  value     = data.azurerm_image.imagedata
  sensitive = true
}