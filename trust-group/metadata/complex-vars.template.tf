# List of well known subnets with configuration
# Expressed as map of object
variable "xxx_well_known_subnets" {
  type = map(object({
    address_prefix = string
  }))
}

# List of required private DNS zones
variable "xxx_private_dns_zones" {
  type = map(object({
    domain = string
  }))
}
