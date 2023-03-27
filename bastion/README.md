  # Overview

When developing new capabilities in (or debugging) Curtain Wall it's necessary to inspect outcomes directly. When Curtain Wall is installed in a private network, one way to do that is to SSH into the VM via Bastion. In cases where there is no other Bastion available, this module facilitates creation of a temporary instance.  
It creates:  
1. A public IP for connecting to the Bastion  
2. The Bastion itself.  

Please note this is intended to be temporary. Remove the Bastion once debugging and research tasks are complete.  

&nbsp;
# References to other module outputs

- tg_{resource group}.resource_group
- tg_{resource group}.well_known_subnets