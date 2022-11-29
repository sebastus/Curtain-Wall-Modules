variable "resource_group" {
  type = any
}

variable "container-dns-name" {
  type    = string
  default = "aci-instance"
}

variable "container-name" {
  type    = string
  default = "hello-world"
}
variable "container-image" {
  type    = string
  default = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
}
variable "container-cpu" {
  type    = string
  default = "0.5"
}
variable "container-memory" {
  type    = string
  default = "1.5"
}