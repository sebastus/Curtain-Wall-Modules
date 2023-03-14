output "linux-vms" {
  value     = var.xxx_count_of_vm != 0 ? module.linux-vm : null
  sensitive = true
}
