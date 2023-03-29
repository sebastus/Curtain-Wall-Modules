variable "os_variant" {
  description = "The operating system being used"
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
}