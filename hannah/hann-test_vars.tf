

# ############################
# Trust group: hann-test
# Instance ID: b88bb4a4-373d-4674-ac47-ebfb666d3f05
# ############################
variable "hann-test_tg_base_name" {
  description = "String: base name of created resources"
  type        = string
  default     = "my-trust"
}

variable "hann-test_create_resource_group" {
  description = "Boolean: create the resource group or ingest existing."
  type        = bool
  default     = true
}
variable "hann-test_existing_resource_group_name" {
  description = "String: name of the existing resource group to ingest."
  type        = string
  default     = ""
}

variable "hann-test_create_law" {
  description = "Boolean: create a log analytics workspace or not."
  type        = bool
  default     = true
}

variable "hann-test_create_managed_identity" {
  description = "Boolean: create a user defined managed identity or ingest existing."
  type        = bool
  default     = true
}
variable "hann-test_existing_managed_identity_name" {
  description = "String: name of the existing managed identity to ingest."
  type        = string
  default     = ""
}
variable "hann-test_existing_managed_identity_rg" {
  description = "String: name of the resource group of the existing managed identity to ingest."
  type        = string
  default     = ""
}

variable "hann-test_create_acr" {
  description = "Boolean: create an Azure Container Registry or not."
  type        = bool
  default     = false
}
variable "hann-test_create_kv" {
  description = "Boolean: create a Key Vault or not."
  type        = bool
  default     = false
}
variable "hann-test_existing_kv_name" {
  description = "String: if ingesting an existing KV, its name."
  type        = string
  default     = ""
}
variable "hann-test_existing_kv_rg_name" {
  description = "String: if ingesting an existing KV, its resource group"
  type        = string
  default     = ""
}

variable "hann-test_create_vnet" {
  description = "Boolean: create a VNET or ingest existing."
  type        = bool
  default     = true
}
variable "hann-test_new_vnet_address_space" {
  description = "String: if creating a new VNET, its address space represented as a CIDR."
  type        = string
  default     = "10.1.0.0/16"
}
variable "hann-test_existing_vnet_rg_name" {
  description = "String: if ingesting an existing VNET, its resource group."
  type        = string
  default     = "rg-networking"
}
variable "hann-test_existing_vnet_name" {
  description = "String: if ingesting an existing VNET, its name."
  type        = string
  default     = "vnet"
}

variable "hann-test_create_well_known_subnets" {
  description = "Boolean: create the well known subnets or ingest existing."
  type        = bool
  default     = true
}

variable "hann-test_is_tfstate_home" {
  description = "Boolean: create the tfstate storage."
  type        = bool
  default     = false
}
variable "hann-test_tfstate_storage_key" {
  description = "String: Name of the tfstate storage blob."
  type        = string
  default     = "state"
}

variable "hann-test_well_known_subnets" {
  type = map(object({
    address_prefix = string
  }))
}
# ############################
# END: b88bb4a4-373d-4674-ac47-ebfb666d3f05
# ############################
