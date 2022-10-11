variable "resource_group" {
  type = any
}

variable "instance_index" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "mi_id" {
  type = string
}

variable "azdo_org_name" {
  type = string
}

variable "azdo_build_agent_name" {
  type = string
}

variable "azdo_agent_version" {
  type = string
}

variable "azdo_pool_name" {
  type = string
}

variable "environment_demand_name" {
  type = string
}

variable "azdo_pat" {
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
    RedHat = {
      publisher = "center-for-internet-security-inc"
      offer     = "cis-rhel-8-l2"
      sku       = "cis-rhel8-l2"
      version   = "latest"
      plan = {
        name      = "cis-rhel8-l2"
        product   = "cis-rhel-8-l2"
        publisher = "center-for-internet-security-inc"
      }
      cloud_init_file_name = "cloud-init-redhat.tftpl"
    }
  }
}
