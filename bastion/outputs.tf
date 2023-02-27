output "bastion" {
    value     = azurerm_bastion_host.bastion
    sensitive = true
}