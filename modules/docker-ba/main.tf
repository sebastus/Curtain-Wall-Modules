#
# Create the container group
#
resource "azurerm_container_group" "cg" {
  name                = "cg-dockerba"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  ip_address_type     = "Public"
  dns_name_label      = var.container-dns-name
  os_type             = "Linux"

  container {
    name   = var.container-name
    image  = var.container-image
    cpu    = var.container-cpu
    memory = var.container-memory


    environment_variables = var.container-envvars
    
    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}

#
# The container task that builds the container image
#
resource "azurerm_container_registry_task" "acrt" {
  name = "acrt-dockerba"

  container_registry_id = var.azurerm_container_registry_id

  platform {
    os = "Linux"
  }

  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = var.repo_url
    context_access_token = var.azdo_pat
    image_names          = ["helloworld:{{.Run.ID}}"]
  }

  source_trigger {
    name           = "dockerfile_trigger"
    events         = ["commit", "pullrequest"]
    repository_url = "https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Docker-BA"
    source_type    = "VisualStudioTeamService"
    authentication {
      token      = var.azdo_pat
      token_type = "PAT"
    }
    branch  = "main"
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}