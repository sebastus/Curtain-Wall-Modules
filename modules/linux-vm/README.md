# Introduction
This Terraform module adds various Azure resources to the top-level Terraform module for Curtain Wall. The main new resource is an AzDO build agent based on the selected operating system and tools. The VM is created, tools installed, and finally the build agent is added to the designated AzDO agent pool.  
It creates:  
1. A network interface card for the VM  
2. An SSH key pair  
3. A cloud-init script
4. VMs (according to count) with the selected Operating System and tools

# Options
The cloud-init is constructed as a base + snippets. The snippets (called ciparts - cloud-init parts) are selected with option vars.  
* include_terraform  
* include_azcli  
* include_azdo_ba  

## Invocation examples 

See examples in the docs folder.  

## os-variants
Configure the OS variant by supplying one of the following or another of your choosing according to this:

Use a command line similar to the following to find the exact image you want:  
 az vm image list -p center-for-internet-security-inc --offer cis-rhel-8-l2 -l uksouth -o table --all  
  
And another similar to this to get the plan details (if any):  
 az vm image show --urn center-for-internet-security-inc:cis-rhel-8-l2:cis-rhel8-l2:2.0.4  
 
You may need to use the following to accept license terms:  
  az vm image terms accept  -p "center-for-internet-security-inc" -f "cis-rhel-8-l2" --plan "cis-rhel8-l2"  

### Red Hat Enterprise Linux

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

### Ubuntu

    Ubuntu = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
      cloud_init_file_name = "cloud-init-ubuntu.tftpl"
    }

# Notes
Note 1  

variables.tf contains additional information on how to select and configure the operating system selection. That configuration also includes the cloud-init selection.  

Note 2  

An AzDO PAT is required. It is needed to add the new build agent to the agent pool.  

Note 3  

[cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/index.html)

Note 4  

The machine that's running terraform apply needs powershell installed. A Windows computer will have it already. A Linux or WSL host will need [pwsh core](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.3) installed. In this case, also override var.powershell_command to be "pwsh".  
