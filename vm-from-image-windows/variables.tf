variable "resource_group" {
  type = any
}

variable "key_vault" {
  type        = any
  description = "existing key vault"
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

variable "admin_password" {
  type = string
}

variable "log_analytics_workspace_id" {
  type    = string
  default = ""
}

variable "log_analytics_workspace_key" {
  type    = string
  default = ""
}

variable "law_installed" {
  type    = bool
}

variable "install_omsagent" {
  type    = bool
  default = true
}

variable "image_resource_group_name" {
  type = string
}

variable "image_base_name" {
  type = string
}

#
# Names to be generated
#
variable "singleton_resource_names" {
  type = map(object(
    {
      resource_type = string
    }
  ))

  default = {
    nic = { resource_type = "azurerm_network_interface" },
    vm  = { resource_type = "azurerm_windows_virtual_machine" },
    pip = { resource_type = "azurerm_public_ip" },
  }
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
    Windows = {
      publisher            = "MicrosoftWindowsServer"
      offer                = "WindowsServer"
      sku                  = "2022-datacenter-azure-edition"
      version              = "latest"
      cloud_init_file_name = ""
    }
  }
}
