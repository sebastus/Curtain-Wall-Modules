# Introduction 


## Invocation in parent
``` terraform
module "vmss-ba" {
  source = "git::https://dev.azure.com/CrossSight/CrossSight/_git/Curtain-Wall-Modules//vmss-ba"

  count          = var.create_vmss_ba ? 1 : 0
  instance_index = count.index

  base_name      = "bldagnt"
  resource_group = module.rg_xxx.resource_group

  identity_ids     = [module.rg_xxx.managed_identity.id]
  subnet_id        = module.rg_xxx.subnet_id
  managed_image_id = var.managed_image_id
}
```

#### Vars in parent
```terraform
# ########################
# VMSS
# ########################
variable "create_vmss_ba" {
  default = false
}

variable "managed_image_id" {
  type        = string
  description = "The resource id of the OS-disk managed image."
}
```

#### TFVars
```terraform
# create a vmss build agent pool?
create_vmss_ba   = false
managed_image_id = "/subscriptions/xxxxxxxxxxxxxxxx/resourceGroups/rg-myManagedImages/providers/Microsoft.Compute/images/buildAgentImage-1204"
```
