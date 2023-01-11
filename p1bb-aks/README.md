# Introduction 

## Invocation in parent
``` terraform
module "p1bb-aks" {
  source = "git::https://golive@dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-P1BB-AKS"
  #source = "../cw-module-p1bb-aks"

  count               = var.xxx_create_p1bb ? 1 : 0

  dns_prefix          = var.xxx_p1bb_aks_dns_prefix
  admin_username      = var.xxx_p1bb_admin_username

  resource_group      = module.rg_xxx.resource_group
  managed_identity    = module.rg_xxx.managed_identity
  vnet_name           = module.rg_xxx.vnet_name
  vnet_rg_name        = module.rg_xxx.resource_group.name
}
```
### Vars in parent
```terraform
# ########################
# P1 BigBang AKS 
# ########################
variable "xxx_create_p1bb" {
  type    = bool
  default = false
}
variable "xxx_p1bb_aks_dns_prefix" {
  type    = string
  default = ""
}
variable "xxx_p1bb_admin_username" {
  type = string
}
```

### outputs in parent
```terraform
output "aks" {
  value     = var.xxx_create_p1bb ? module.p1bb-aks : null
  sensitive = true
}
```

### TFVars
```terraform
# #########################
# xxx p1bb
# #########################
xxx_create_p1bb         = true
xxx_p1bb_aks_dns_prefix = something
xxx_p1bb_admin_username = azureuser
```

