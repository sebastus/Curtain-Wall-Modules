# outputs from context
output "context_outputs" {
  value = module.context
}

# outputs from remote
output "state_rg_name" {
  value = var.install_remote ? module.remote[0].state_rg_name : null
}

output "state_storage_name" {
  value = var.install_remote ? module.remote[0].state_storage_name : null
}

output "state_container_name" {
  value = var.install_remote ? module.remote[0].state_container_name : null
}

output "state_key" {
  value = var.install_remote ? module.remote[0].state_key : null
}

