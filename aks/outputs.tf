output "aks_ssh_private_key" {
  value     = tls_private_key.ssh.private_key_openssh
  sensitive = true
}

output "aks_host" {
  value = azurerm_kubernetes_cluster.main.kube_config.0.host
}

output "aks_client_certificate_base64" {
  value = azurerm_kubernetes_cluster.main.kube_config.0.client_certificate
}

output "aks_client_key_base64" {
  value = azurerm_kubernetes_cluster.main.kube_config.0.client_key
}

output "aks_cluster_ca_certificate_base64" {
  value = azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate
}
