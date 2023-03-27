#
# Format the cloud-init
#
data "template_cloudinit_config" "config_cloud_init" {
  for_each = var.os_variant

  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/${each.value.cloud_init_file_name}",
      {
        user = "adminbs"
      }
    )
    merge_type = "list(append)+dict(recurse_array)+str()"
  }

  # until we come up with a good reason, put az cli first
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.azcli.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.openvpn.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.pwsh.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.nexus.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.docker.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.terraform.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = each.key == "Ubuntu" ? data.template_file.packer_debian.rendered : data.template_file.packer_redhat.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.sonarqube_server.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.dotnetsdk.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.maven.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  # the build agent should always be included after any tools it should import environment variables from
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.azdo_build_agent.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  # this one should always be last
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.finally.rendered
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}

data "template_file" "finally" {

  template = file("${path.module}/ciparts/finally.tftpl")

  vars = {
    managed_identity_id = var.managed_identity.id
  }

}

data "template_file" "azcli" {

  template = var.include_azcli ? "${file("${path.module}/ciparts/azcli.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# az cli - not included
 - echo ********************************
 - echo az CLI is not included
 - echo ********************************
EOT
}

data "template_file" "openvpn" {

  template = var.include_openvpn ? "${file("${path.module}/ciparts/openvpn.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# OpenVPN - not included
 - echo ********************************
 - echo OpenVPN server is not included
 - echo ********************************
EOT

  vars = {
    storage_account_name = var.storage_account_name
  }
}

data "template_file" "docker" {

  template = var.include_docker ? "${file("${path.module}/ciparts/docker.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# docker - not included
 - echo ********************************
 - echo docker is not included
 - echo ********************************
EOT
}

data "template_file" "nexus" {

  template = var.include_nexus ? "${file("${path.module}/ciparts/nexus.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# nexus - not included
 - echo ********************************
 - echo Nexus Repository Manager is not included
 - echo ********************************
EOT
}

data "template_file" "pwsh" {

  template = var.include_pwsh ? "${file("${path.module}/ciparts/pwsh.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# PowerShell - not included
 - echo ********************************
 - echo PowerShell is not included
 - echo ********************************
EOT
}

data "template_file" "terraform" {

  template = var.include_terraform ? "${file("${path.module}/ciparts/terraform.tftpl")}" : <<-EOT
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

data "template_file" "packer_debian" {

  template = var.include_packer ? "${file("${path.module}/ciparts/packer_debian.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# packer - not included
 - echo ********************************
 - echo Packer CLI is not included
 - echo ********************************
EOT
}

data "template_file" "sonarqube_server" {

  template = var.include_sonarqube_server ? "${file("${path.module}/ciparts/sonarqube_server.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# packer - not included
 - echo ********************************
 - echo Sonarqube Server is not included
 - echo ********************************
EOT
}

data "template_file" "packer_redhat" {

  template = var.include_packer ? "${file("${path.module}/ciparts/packer_redhat.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# packer - not included
 - echo ********************************
 - echo Packer CLI is not included
 - echo ********************************
EOT
}

data "template_file" "dotnetsdk" {

  template = var.include_dotnetsdk ? "${file("${path.module}/ciparts/dotnetsdk.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# dotnetsdk - not included
 - echo ********************************
 - echo dotnetsdk is not included
 - echo ********************************
EOT
}

data "template_file" "maven" {

  template = var.include_maven ? "${file("${path.module}/ciparts/maven.tftpl")}" : <<-EOT
# cloud-config
runcmd:
# Maven - not included
 - echo ********************************
 - echo Maven is not included
 - echo ********************************
EOT
}

data "template_file" "azdo_build_agent" {

  template = var.include_azdo_ba ? "${file("${path.module}/ciparts/azdo-ba.tftpl")}" : <<-EOT
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
    agent_name         = var.azdo_build_agent_name
  }
}