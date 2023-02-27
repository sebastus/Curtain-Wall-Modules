output "emulated-ash" {
    value     = azurerm_windows_virtual_machine.vm
    sensitive = true
}