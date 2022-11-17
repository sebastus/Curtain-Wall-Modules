variable "resource_group" {
  type = any
}

variable "instance_index" {
  type = number
}

variable "base_name" {
  type = string
}

variable "create_pip" {
  type    = bool
  default = false
}

variable "subnet_id" {
  type = string
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

variable "include_terraform" {
  type    = bool
  default = false
}

variable "include_packer" {
  type    = bool
  default = false
}

variable "include_azcli" {
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

variable "log_analytics_workspace_id" {
  type = string
}

variable "log_analytics_workspace_key" {
  type = string
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
      offer                = "UbuntuServer"
      sku                  = "18.04-LTS"
      version              = "latest"
      cloud_init_file_name = "cloud-init-ubuntu.tftpl"
    }
  }
}
