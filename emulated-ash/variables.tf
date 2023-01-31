variable "resource_group" {
  type = any
}

variable "base_name" {
  type = string
}

#
# vm
#
variable "subnet_id" {
  type = string
}
variable "admin_password" {
  type = string
}
variable "asdk_vhd_source_uri" {
  type = string
}
variable "asdk_number_of_cores" {
  default = 48
}


variable "create_managed_identity" {
  type = bool
}
variable "existing_managed_identity_name" {
  type = string
}
variable "existing_managed_identity_rg" {
  type = string
}

variable "create_key_vault" {
  type = bool
}
variable "existing_key_vault_name" {
  type = string
}
variable "existing_key_vault_rg" {
  type = string
}

#
# Subnet for private endpoints
#
variable "pe_subnet_resource_group_name" {
  type = string
}
variable "pe_subnet_vnet_name" {
  type = string
}
variable "create_pe_subnet" {
  default = true
}
variable "new_pe_subnet_address_prefixes" {
  type = list(string)
}
variable "existing_pe_subnet_name" {
  type = string
}

#
# Names to be generated
#
variable "singleton_resource_names" {
  type = map(object(
    {
      resource_type = string,
      random_length = number
    }
  ))

  default = {
    nic  = { resource_type = "azurerm_network_interface", random_length = 0 },
    vm   = { resource_type = "azurerm_windows_virtual_machine", random_length = 0 },
    mi   = { resource_type = "azurerm_user_assigned_identity", random_length = 0 },
    kv   = { resource_type = "azurerm_key_vault", random_length = 4 },
    asdk = { resource_type = "azurerm_image", random_length = 0 },
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
