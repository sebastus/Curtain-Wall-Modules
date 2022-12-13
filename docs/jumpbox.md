### As a jumpbox:  
```terraform
module "jumpbox" {
  source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-VM"

  count          = var.xxx_count_of_jumpboxes
  instance_index = count.index
  base_name      = "jumpbox"

  resource_group = module.rg_xxx.resource_group
  identity_ids   = null
  subnet_id      = module.rg_xxx.subnet_id

  include_azcli = true
}
```

### Vars in parent
```terraform
# ########################
# Jumpboxes
# ########################
variable "xxx_count_of_jumpboxes" {
  default = 0
}
```

### outputs in parent
```terraform
output "jumpboxes" {
  value     = var.xxx_count_of_jumpboxes != 0 ? module.jumpbox : null
  sensitive = true
}
```

### TFVars
```terraform
# #########################
# xxx jumpbox
# #########################
xxx_count_of_jumpboxes   = 1
```

