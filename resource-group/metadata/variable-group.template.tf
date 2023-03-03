#
# Variable Group
#
resource "azuredevops_variable_group" "rg_xxx" {
  count = var.hub_install_remote ? 1 : 0

  name         = "${var.azurerm_backend_key}__${var.cw_environment_name}__xxx"
  project_id   = data.azuredevops_project.curtain_wall.id
  description  = "CW variables for resource group xxx."
  allow_access = true

  dynamic "variable" {
    for_each = local.xxx_variables
    content {
      name         = variable.key
      value        = variable.value["value"]
      secret_value = variable.value["secret_value"]
      is_secret    = variable.value["is_secret"]
    }
  }
}

# codegen adds local.xxx_variables below
#