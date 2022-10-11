output "private_key_openssh" {
  value     = tls_private_key.ssh.private_key_openssh
  sensitive = true
}