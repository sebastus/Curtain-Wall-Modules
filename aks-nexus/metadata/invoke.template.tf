module "nexus_xxx" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Modules//aks-nexus"
  # source = "../../Curtain-Wall-Modules/aks-nexus"

  nexus_instance_name               = var.xxx_nexus_instance_name
  base_name                         = "${var.base_name}-nexus-xxx"
  resource_group                    = module.rg_xxx.resource_group
  acr                               = module.rg_xxx.acr
  aks                               = module.aks_xxx.aks
  aks_managed_identity              = module.aks_xxx.aks_managed_identity
  storage_file_share_name           = var.xxx_nexus_storage_file_share_name
  enable_ingress                    = var.xxx_nexus_enable_ingress
  nexus_admin_password              = var.xxx_nexus_admin_password
  agentPoolNodeSelector             = var.xxx_nexus_agentPoolNodeSelector
  init-nexus-container-tag          = var.xxx_nexus_init_nexus_container_tag
  cluster_issuer_email              = var.xxx_nexus_cluster_issuer_email
  use_production_certificate_issuer = var.xxx_nexus_use_production_certificate_issuer
}
