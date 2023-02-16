locals {
  image_name = "azdo-build-agent"
}
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group.name
}

#
# The task that builds the container image
#
resource "null_resource" "push_local_agent_image" {
  triggers = {
    build_number = "${var.agent_tag}"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = "${path.module}/../container-images/build-agent"
    command     = <<-EOT
        az acr build -r ${var.acr_name} -t ${local.image_name}:latest -t ${local.image_name}:${var.agent_tag} .
    EOT
  }
}

resource "helm_release" "agents" {
  for_each          = var.agent_pools
  name              = each.key
  chart             = "${path.module}/../helm-charts/keda-azdo-build-agent"
  wait              = true
  dependency_update = true

  set {
    name  = "image.repository"
    value = "${data.azurerm_container_registry.acr.login_server}/${local.image_name}"
  }
  set {
    name  = "image.tag"
    value = var.agent_tag
  }
  set {
    name  = "azdo.url"
    value = var.azdo_repo_url
  }
  set_sensitive {
    name  = "azdo.agentManagementToken"
    value = var.azdo_pat
  }
  set {
    name  = "azdo.pool.name"
    value = each.value.azdo_agent_pool
  }

  set {
    name  = "agentPoolNodeSelector"
    value = each.value.aks_node_selector
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
        agentPool="${each.value.azdo_agent_pool}"
        agentName="${each.key}-keda-azdo-build-agent-placeholder"
        echo "$agentName"
        
        poolId=$(curl -f -s -u :${var.azdo_pat} "${var.azdo_repo_url}/_apis/distributedtask/pools?poolName=$agentPool&api-version=7.1-preview.1" | jq ".value[0].id")
        echo "pool id: $poolId"

        sleep 5

        agentId=$(curl -f -s -u :${var.azdo_pat} "${var.azdo_repo_url}/_apis/distributedtask/pools/$poolId/agents?api-version=7.1-preview.1" | jq -r ".value | map(select(.name == \"$agentName\")) | .[0] | .id")
        echo "agentId id: $agentId"

        curl -s -f -u :${var.azdo_pat} -X PATCH -d "{ \"id\": \"$agentId\", \"enabled\": \"false\", \"status\": \"offline\"}" -H "Content-Type: application/json" "${var.azdo_repo_url}/_apis/distributedtask/pools/$poolId/agents/$agentId?api-version=7.1-preview.1"
    EOT
  }

  depends_on = [
    null_resource.push_local_agent_image
  ]
}

