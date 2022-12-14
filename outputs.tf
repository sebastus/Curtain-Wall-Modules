# outputs from context
output "resource_group" {
  value = module.context.resource_group
}

output "vnet_name" {
  value = module.context.vnet_name
}

output "managed_identity" {
  value = module.context.managed_identity
}

output "subnet_id" {
  value = module.context.subnet_id
}

output "law_id" {
  value = module.context.law_id
}

output "law_key" {
  value = module.context.law_key
}

output "acr_id" {
  value = module.context.acr_id
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

