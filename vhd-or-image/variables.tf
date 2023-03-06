variable "hcl_path_and_file_name" {
  description = "Relative (to main.tf) path and file name of hcl file."
  type        = string
}
variable "arm_client_id" {
  description = "Credentials used by packer to create Azure resources"
  type        = string
}
variable "arm_client_secret" {
  description = "Credentials used by packer to create Azure resources"
  type        = string
}
variable "install_password" {
  description = "Password used in the Windows Packer vm during installation of software."
  type        = string
}
variable "local_temp" {
  description = "The toowoxx/packer provider uses a temp folder on the system where Packer is being run."
  type        = string
}

# if using existing vnet...
variable "vnet_name" {
  description = "Name of existing vnet to use,"
  default     = ""
}
variable "vnet_resource_group" {
  description = "Resource group containing existing vnet."
  default     = ""
}
variable "vnet_subnet" {
  description = "Name of existing subnet to use."
  default     = ""
}

variable "vhd_or_image" {
  default = "image"
}

# if image
variable "image_base_name" {
  default = ""
}
variable "image_resource_group_name" {
  type = string
}
#elseif vhd
variable "vhd_resource_group_name" {
  type = string
}
variable "vhd_capture_name_prefix" {
  type = string
}
variable "vhd_storage_account" {
  type = string
}
# endif
