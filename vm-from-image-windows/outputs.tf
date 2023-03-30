output "vm-from-image-windows" {
  value     = azurerm_windows_virtual_machine.imagevm
  sensitive = true
}