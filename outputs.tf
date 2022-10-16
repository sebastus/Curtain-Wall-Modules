output "build-agents" {
  value     = module.build-agent
  sensitive = true
}
output "jumpboxes" {
  value     = module.jumpbox
  sensitive = true
}
#################

output "state_rg_name" {
  value = var.install_remote ? module.remote[0].state_rg_name : ""
}

output "state_storage_name" {
  value = var.install_remote ? module.remote[0].state_storage_name : ""
}

output "state_container_name" {
  value = var.install_remote ? module.remote[0].state_container_name : ""
}

output "state_key" {
  value = var.install_remote ? module.remote[0].state_key : ""
}

##############
