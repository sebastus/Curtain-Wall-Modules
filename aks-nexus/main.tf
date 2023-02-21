locals {
  image_name = "nexus-init"
  nexus_ingress_class_name          = var.nexus_instance_name
}

#Azure Storage Account

resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = var.base_name
  resource_type = each.value.resource_type
}

resource "azurerm_storage_account" "nexus_storage" {
  name                     = azurecaf_name.generated["nexusstore"].result
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  account_replication_type = "LRS"
  network_rules {
    default_action = "Allow"
  }
}

# Azure File Share

resource "azurerm_storage_share" "nexus_storage_share" {
  name                 = var.storage_file_share_name
  storage_account_name = azurerm_storage_account.nexus_storage.name
  quota                = 1000
}

# Public IP for ingress (if required)

resource "azurerm_public_ip" "nexus_ingress" {
  count = var.enable_ingress ? 1 : 0
  name                = azurecaf_name.generated["nexuspublicip"].result
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${azurecaf_name.generated["nexuspublicip"].result}-nexus"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_role_assignment" "aks_ip_contributor_role" {
  count = var.enable_ingress ? 1 : 0
  scope                = azurerm_public_ip.nexus_ingress[0].id
  role_definition_name = "Contributor"
  principal_id         = var.aks_managed_identity.principal_id
}

resource "azurerm_role_assignment" "aks_kubelet_id_ip_contributor_role" {
  count = var.enable_ingress ? 1 : 0
  scope                = azurerm_public_ip.nexus_ingress[0].id
  role_definition_name = "Contributor"
  principal_id         = var.aks.kubelet_identity[0].object_id
}

#
# The task that builds the container image
#
resource "null_resource" "push_nexus_init_image" {
  triggers = {
    build_number = "${var.init-nexus-container-tag}"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = "${path.module}/../container-images/nexus-init"
    command     = <<-EOT
        az acr build -r ${var.acr.name} -t ${local.image_name}:latest -t ${local.image_name}:${var.init-nexus-container-tag} .
    EOT
  }
}

# Helm chart

resource "helm_release" "nexus" {
  name              = var.nexus_instance_name
  chart             = "${path.module}/../helm-charts/nexus"
  timeout           = var.nexus_readiness_timeout
  wait              = true
  wait_for_jobs     = true
  dependency_update = true

  set {
    name  = "initJob.repository"
    value = "${var.acr.login_server}/nexus-init"
  }
  set {
    name  = "initJob.tag"
    value = var.init-nexus-container-tag
  }
  set {
    name  = "storage.accountName"
    value = azurerm_storage_account.nexus_storage.name
  }
  set_sensitive {
    name  = "storage.primaryKey"
    value = azurerm_storage_account.nexus_storage.primary_access_key
  }
  set {
    name  = "storage.shareName"
    value = var.storage_file_share_name
  }
  set {
    name  = "storage.resourceGroupName"
    value = var.resource_group.name
  }
  set {
    name  = "ingress.enabled"
    value = var.enable_ingress
  }

  set {
    name  = "ingress.nexus.hostName"
    value = var.enable_ingress ? azurerm_public_ip.nexus_ingress[0].fqdn : ""
  }

  set {
    name  = "ingress.nexus.ingressClassName"
    value = local.nexus_ingress_class_name
  }

  set {
    name  = "ingress.nexus.certClusterIssuerSuffix"
    value = var.use_production_certificate_issuer ? "" : "-staging"
  }

  set_sensitive {
    name  = "nexus.admin.password"
    value = var.nexus_admin_password
  }

  set {
    name  = "nexus.serviceUri"
    value = "http://${var.nexus_instance_name}-nexus-svc.${var.nexus_instance_name}-nexus"
  }

  set {
    name  = "agentPoolNodeSelector"
    value = var.agentPoolNodeSelector
  }

  # set {
  #   name  = "nexus-ingress.controller.ingressClass"
  #   value = local.nexus_ingress_class_name
  # }

  set {
    name  = "nexus-ingress.controller.ingressClassResource.name"
    value = local.nexus_ingress_class_name
  }
  set {
    name  = "nexus-ingress.controller.ingressClassResource.controllerValue"
    value = "k8s.io/${local.nexus_ingress_class_name}"
  }
  set {
    name  = "nexus-ingress.controller.service.loadBalancerIP"
    value = var.enable_ingress ? azurerm_public_ip.nexus_ingress[0].ip_address : ""
  }
  set {
    name  = "nexus-ingress.controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
    value = var.enable_ingress ? azurerm_public_ip.nexus_ingress[0].domain_name_label : ""
  }
  set {
    name  = "nexus-ingress.controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = var.resource_group.name
  }

  set {
    name  = "clusterIssuer.email"
    value = var.cluster_issuer_email
  }

  depends_on = [
    azurerm_role_assignment.aks_ip_contributor_role,
    null_resource.push_nexus_init_image,
    azurerm_public_ip.nexus_ingress
  ]
}