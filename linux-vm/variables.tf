variable "resource_group" {
  type = any
}

variable "instance_index" {
  type = number
}

variable "base_name" {
  type = string
}

variable "managed_identity" {
  description = "User assigned managed identity object"
  type        = any
}

variable "key_vault" {
  type        = any
  description = "existing key vault"
}

variable "create_pip" {
  type    = bool
  default = false
}

variable "subnet" {
  type = any
}

variable "identity_ids" {
  type = list(string)
}

variable "azdo_org_name" {
  type    = string
  default = ""
}

variable "azdo_build_agent_name" {
  type    = string
  default = ""
}

variable "azdo_agent_version" {
  type    = string
  default = ""
}

variable "azdo_pool_name" {
  type    = string
  default = ""
}

variable "environment_demand_name" {
  type    = string
  default = ""
}

variable "azdo_pat" {
  type    = string
  default = ""
}

variable "include_azdo_ba" {
  type    = bool
  default = false
}

variable "include_openvpn" {
  type    = bool
  default = false
}
variable "storage_account_name" {
  type    = string
}

variable "include_nexus" {
  type    = bool
  default = false
}

variable "include_dotnetsdk" {
  type    = bool
  default = false
}

variable "include_maven" {
  type    = bool
  default = false
}

variable "include_terraform" {
  type    = bool
  default = false
}

variable "include_packer" {
  type    = bool
  default = false
}

variable "include_sonarqube_server" {
  type    = bool
  default = false
}

variable "include_azcli" {
  type    = bool
  default = false
}

variable "include_docker" {
  type    = bool
  default = false
}

variable "include_pwsh" {
  type    = bool
  default = false
}

variable "terraform_version" {
  type    = string
  default = "1.3.2"
}

variable "powershell_command" {
  type    = string
  default = "powershell"
}

variable "install_omsagent" {
  type    = bool
  default = true
}

variable "law_installed" {
  description = "tells this module if log analytics workspace is available"
  type        = bool
}

variable "log_analytics_workspace_id" {
  type    = string
  default = ""
}

variable "log_analytics_workspace_key" {
  type    = string
  default = ""
}

variable "vm_size" {
  type    = string
  default = "Standard_D4ds_v5"
}

# include only one os variant in this variable at a time.
#
# use a command line similar to the following to find the exact image you want:
# az vm image list -p center-for-internet-security-inc --offer cis-rhel-8-l2 -l uksouth -o table --all
# 
# and another similar to this to get the plan details (if any):
# az vm image show --urn center-for-internet-security-inc:cis-rhel-8-l2:cis-rhel8-l2:2.0.4
#
# you may need to use the following to accept license terms:
#  az vm image terms accept  -p "center-for-internet-security-inc" -f "cis-rhel-8-l2" --plan "cis-rhel8-l2"
variable "os_variant" {
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }))
    cloud_init_file_name = string
  }))
  default = {
    Ubuntu = {
      publisher            = "Canonical"
      offer                = "0001-com-ubuntu-server-focal"
      sku                  = "20_04-lts-gen2"
      version              = "latest"
      cloud_init_file_name = "cloud-init-ubuntu.tftpl"
    }
  }
}
