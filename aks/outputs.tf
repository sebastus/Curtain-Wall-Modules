output "aks_ssh_private_key" {
  value     = tls_private_key.ssh.private_key_openssh
  sensitive = true
}

output "aks" {
  value = azurerm_kubernetes_cluster.main
}

output "aks_managed_identity" {
  value = azurerm_user_assigned_identity.mi_aks
}

