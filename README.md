# Introduction 
VM module designed to work with Curtain Wall project.


# os-variants
Configure the OS variant by supplying one of the following or another of your choosing according to this:

Use a command line similar to the following to find the exact image you want:  
 az vm image list -p center-for-internet-security-inc --offer cis-rhel-8-l2 -l uksouth -o table --all  
  
And another similar to this to get the plan details (if any):  
 az vm image show --urn center-for-internet-security-inc:cis-rhel-8-l2:cis-rhel8-l2:2.0.4  
 
You may need to use the following to accept license terms:  
  az vm image terms accept  -p "center-for-internet-security-inc" -f "cis-rhel-8-l2" --plan "cis-rhel8-l2"  

## Red Hat Enterprise Linux

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

## Ubuntu

    Ubuntu = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
      cloud_init_file_name = "cloud-init-ubuntu.tftpl"
    }
