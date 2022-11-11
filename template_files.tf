data "template_file" "azcli" {

  template = var.include_azcli ? "${file("${path.module}/cipart-azcli.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# az cli - not included
 - echo ********************************
 - echo az CLI is not included
 - echo ********************************
EOT
}

data "template_file" "terraform" {

  template = var.include_terraform ? "${file("${path.module}/cipart-terraform.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# terraform - not included
 - echo ********************************
 - echo Terraform CLI is not included
 - echo ********************************
EOT

  vars = {
    terraform_version = var.terraform_version
  }
}

data "template_file" "azdo_build_agent" {

  template = var.include_terraform ? "${file("${path.module}/cipart-azdo-ba.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# AzDO build agent - not included
 - echo ********************************
 - echo AzDO build agent is not included
 - echo ********************************
EOT

  vars = {
    user               = "adminbs"
    azdo_agent_version = var.azdo_agent_version
    hub_environment    = var.environment_demand_name
    pat_token          = var.azdo_pat                                 # /
    azdo_org           = "https://dev.azure.com/${var.azdo_org_name}" # --- These 3 must be provided by the user via ENV or pipeline params. See README.md
    build_pool         = var.azdo_pool_name                           # \
    agent_name         = "${var.azdo_build_agent_name}_${var.instance_index}"
  }
}

