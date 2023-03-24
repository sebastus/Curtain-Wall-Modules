output "private_key_openssh" {
  value     = tls_private_key.ssh.private_key_openssh
  sensitive = true
}

output "linux-vm" {
  value     = azurerm_linux_virtual_machine.vm
  sensitive = true
}

output "subnet" {
  value = var.subnet
}