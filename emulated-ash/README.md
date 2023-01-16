# Introduction

# Invocation samples

## Invocation code in parent
```terraform
# ########################
# Emulated ASH
# ########################
module "emulated-ash" {
  #source = "git::https://CrossSight@dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Module-Emulated-ASH.CrossSight"
  source = "../cw-module-emulated-ash"

  base_name      = "cw-ash"

  resource_group = module.rg_xxx.resource_group
  subnet_id      = module.rg_xxx.subnet_id
  admin_password = var.xxx_admin_password

  asdk_vhd_source_uri       = var.xxx_asdk_vhd_source_uri
  asdk_storage_account_name = var.xxx_asdk_storage_account_name
  asdk_storage_account_rg   = var.xxx_asdk_storage_account_rg

  create_managed_identity        = var.xxx_ash_create_managed_identity
  existing_managed_identity_name = var.xxx_ash_existing_managed_identity_name
  existing_managed_identity_rg   = var.xxx_ash_existing_managed_identity_rg

  create_key_vault        = var.xxx_ash_create_key_vault
  existing_key_vault_name = var.xxx_ash_existing_key_vault_name
  existing_key_vault_rg   = var.xxx_ash_existing_key_vault_rg

  pe_subnet_address_prefixes = var.xxx_pe_subnet_address_prefixes
  vnet_resource_group_name   = var.xxx_vnet_resource_group_name
  vnetName                   = var.xxx_vnetName
}
```

## variables in parent
```terraform
# ########################
# Emulated ASH
# ########################

#
# vm
#
variable "xxx_admin_password" {
    type = string
}
variable "xxx_asdk_vhd_source_uri" {
  type = string
}
variable "xxx_asdk_storage_account_name" {
  type = string
}
variable "xxx_asdk_storage_account_rg" {
  type = string
}
variable "xxx_asdk_number_of_cores" {
  default = 32
}

#
# managed identity
#
variable "xxx_ash_create_managed_identity" {
  type = bool
}
variable "xxx_ash_existing_managed_identity_name" {
  type = string
}
variable "xxx_ash_existing_managed_identity_rg" {
  type = string
}

#
# key vault
#
variable "xxx_ash_create_key_vault" {
  type = bool
}
variable "xxx_ash_existing_key_vault_name" {
  type = string
}
variable "xxx_ash_existing_key_vault_rg" {
  type = string
}

#
# Subnet for private endpoints
#
variable "xxx_pe_subnet_address_prefixes" {
  type = list(string)
}
variable "xxx_vnet_resource_group_name" {
  type = string
}
variable "xxx_vnetName" {
  type = string
}

```

## outputs
```terraform
# ########################
# Emulated ASH
# ########################
```

## tfvars
```terraform
# ########################
# xxx Emulated ASH
# ########################
xxx_ash_create_managed_identity        = true
xxx_ash_existing_managed_identity_name = ""
xxx_ash_existing_managed_identity_rg   = ""
xxx_ash_create_key_vault               = true
xxx_ash_existing_key_vault_name        = ""
xxx_ash_existing_key_vault_rg          = ""
xxx_pe_subnet_address_prefixes         = ["10.1.5.0/24"]
xxx_vnet_resource_group_name           = "rg-name"
xxx_vnetName                           = "vnet-name"
xxx_admin_password                     = "some password"
xxx_asdk_vhd_source_uri                = "https://some vhd uri"
xxx_asdk_storage_account_name          = "storage_account_name"
xxx_asdk_storage_account_rg            = "resource_group_name"
xxx_asdk_number_of_cores               = 32
```