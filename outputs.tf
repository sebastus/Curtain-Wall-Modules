output "build-agents" {
  value     = var.count_of_infra_agents != 0 ? module.build-agent : null
  sensitive = true
}
output "jumpboxes" {
  value     = var.count_of_jumpboxes != 0 ? module.jumpbox : null
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
