#
# Variable Group
#
resource "azuredevops_variable_group" "core" {
  name         = "${var.azurerm_backend_key}__${var.hub_cw_environment_name}__xxx"
  project_id   = data.azuredevops_project.curtain_wall.id
  description  = "CW variables for resource group xxx."
  allow_access = true

  dynamic "variable" {
    for_each = local.xxx_variables
    content {
      name      = variable.key
      value     = variable.value["value"]
      is_secret = variable.value["is_secret"]
    }
  }
}

# codegen adds local.xxx_variables below
#