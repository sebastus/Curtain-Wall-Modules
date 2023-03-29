# Introduction
This Terraform module adds a linux vm and its direct dependencies to a trust-group.    
Specifically:  
1. A network interface card for the VM  
2. An SSH key pair (which will be stored in the key vault)  
3. A cloud-init script
4. VM with the selected Operating System and tools

&nbsp;
# Options
The cloud-init is constructed as a base + snippets. The snippets (called ciparts - cloud-init parts) are selected with option vars:  
* include_terraform  
* include_azcli <- This one should always be true
* include_azdo_ba  
* and several more. Check schema.json for the complete list.

&nbsp;
# Specific use cases
A small set of special use cases are implemented in linux-vm:  
* OpenVPN server  
* AzDO build agent  
* SonarQube server  
* Nexus Repository Server  

Otherwise, it's a trivial matter to add additional ciparts as needed for your use case.  

&nbsp;
# How to use

At the Curtain Wall modules level, run

`python codegen/src/codegen.py add -m linux-vm -g {resource group name}`

&nbsp;
# Execution requirements

This module can be run on a Windows or Linux platform.  

The terraform script uses a local-exec provisioner, which in turn uses powershell. For this to succeed,  
find the line in the invocation script:  

```powershell_command       = "powershell"```

It should specify 'powershell' on a Windows platform and 'pwsh' on a linux platform. The platform running  
terraform will need powershell installed.  

&nbsp;
# References to other module outputs

- tg_{resource group}.resource_group
- tg_{resource group}.managed_identity
- tg_{resource group}.well_known_subnets
- tg_{resource group}.log_analytics_workspace

&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{ tgname }_linuxvm_base_name = "linux-vm"
{ tgname }_linuxvm_vm_size   = "Standard_D4ds_v5"
{ tgname }_linuxvm_subnet    = "default"

{ tgname }_linuxvm_create_pip = false

{ tgname }_include_azdo_ba              = false
{ tgname }_azdo_agent_version           = "2.206.1"
{ tgname }_azdo_pool_name               = "myPool"
{ tgname }_azdo_build_agent_name        = "agent"
{ tgname }_azdo_environment_demand_name = "InfraInstaller"

{ tgname }_include_openvpn      = false
{ tgname }_storage_account_name = ""

{ tgname }_linuxvm_install_omsagent = true
{ tgname }_include_sonarqube_server = false
{ tgname }_include_azcli            = true
{ tgname }_include_nexus            = false
{ tgname }_include_docker           = false
{ tgname }_include_pwsh             = false
{ tgname }_include_packer           = false
{ tgname }_include_dotnetsdk        = false
{ tgname }_include_maven            = false

{ tgname }_include_terraform = false
{ tgname }_terraform_version = "1.3.2"
```
*{rg name}.tf:* 
```
Terraform module "linux-vm" 
```
*outputs.tf:*
```
module.linux-vms
```

## os-variants
Configure the OS variant in variables.tf by supplying one of the following or  
another of your choosing according to this:

Use a command line similar to the following to find the exact image you want:  
 `az vm image list -p center-for-internet-security-inc --offer cis-rhel-8-l2 -l uksouth -o table --all`  
  
And another similar to this to get the plan details (if any):  
 `az vm image show --urn center-for-internet-security-inc:cis-rhel-8-l2:cis-rhel8-l2:2.0.4`  
 
You may need to use the following to accept license terms:  
  `az vm image terms accept  -p "center-for-internet-security-inc" -f "cis-rhel-8-l2" --plan "cis-rhel8-l2"`  

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
