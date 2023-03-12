# Introduction

# Invocation samples

## Invocation code in parent
```terraform
# ########################
# xxx - Emulated ASH
# ########################
module "emulated-ash" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//emulated-ash"
  #source = "../../Curtain-Wall-Modules/emulated-ash"

  base_name      = "cw-ash"

  resource_group = module.rg_xxx.resource_group
  subnet_id      = module.rg_xxx.subnet_id
  admin_password = var.xxx_ash_admin_password

  asdk_vhd_source_uri  = var.xxx_ash_vhd_source_uri
  asdk_number_of_cores = var.xxx_ash_number_of_cores

  create_managed_identity        = var.xxx_ash_create_managed_identity
  existing_managed_identity_name = var.xxx_ash_existing_managed_identity_name
  existing_managed_identity_rg   = var.xxx_ash_existing_managed_identity_rg

  create_key_vault        = var.xxx_ash_create_key_vault
  existing_key_vault_name = var.xxx_ash_existing_key_vault_name
  existing_key_vault_rg   = var.xxx_ash_existing_key_vault_rg

  create_pe_subnet              = var.xxx_ash_create_pe_subnet
  new_pe_subnet_address_prefix  = var.xxx_ash_new_pe_subnet_address_prefix
  pe_subnet_resource_group_name = var.xxx_ash_vnet_resource_group_name
  pe_subnet_vnet_name           = var.xxx_ash_vnet_name
  existing_pe_subnet_name       = var.xxx_ash_existing_pe_subnet_name
}
```

## variables in parent
```terraform
# ########################
# xxx - Emulated ASH
# ########################

#
# vm
#
variable "xxx_ash_admin_password" {
    type = string
}
variable "xxx_ash_vhd_source_uri" {
  type = string
}
variable "xxx_ash_number_of_cores" {
  default = 32
}

#
# managed identity
# An existing managed identity will need these role assignments:
# 1) Reader / scope = the resource group of the new ASH vm and key vault
# 2) Key Vault Secrets User / scope = the key vault
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
variable "xxx_ash_pe_subnet_address_prefixes" {
  type = list(string)
}
variable "xxx_ash_vnet_resource_group_name" {
  type = string
}
variable "xxx_ash_vnet_name" {
  type = string
}

```

## outputs
```terraform
# ########################
# xxx - Emulated ASH
# ########################
```

## tfvars
```terraform
# ########################
# xxx Emulated ASH
# ########################

# relevant to the VM
xxx_ash_admin_password                     = "some password"
xxx_ash_vhd_source_uri                = "https://some vhd uri"
xxx_ash_number_of_cores               = 32

# managed identity
xxx_ash_create_managed_identity        = true
xxx_ash_existing_managed_identity_name = ""
xxx_ash_existing_managed_identity_rg   = ""

# key vault
xxx_ash_create_key_vault               = true
xxx_ash_existing_key_vault_name        = ""
xxx_ash_existing_key_vault_rg          = ""

# private endpoint
xxx_ash_pe_subnet_address_prefixes         = ["10.1.5.0/24"]
xxx_ash_vnet_resource_group_name           = "rg-name"
xxx_ash_vnet_name                           = "vnet-name"
```
