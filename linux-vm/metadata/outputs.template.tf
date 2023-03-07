output "build-agents" {
  value     = var.xxx_ba_count_of_build_agents != 0 ? module.build-agent : null
  sensitive = true
}
