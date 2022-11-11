# Curtain Wall: DevSecOps In A Box
Curtain Wall is a system of tooling for AzDO/Azure projects.  

It is:  
* A DevSecOps system for AzDO/Azure.  
* A collection of Terraform modules  
* Installed in its own VNET/Subnet or existing.  
* Provided with an optional Bastion, if needed.  

# Getting Started
To install, make a copy of sample.tfvars and tailor to your environment.  
Login to az cli:  
- az login -t \<your Azure AD tenant id\>  
- az account set -s \<your Azure subscription id or name\>  

The simplest approach is to run tf init/plan/apply locally and keep state local. The alternative is to use the bootstrap script. It will install everything locally and then migrate tfstate to a remote backend. From that point on use the included AzDO pipeline to make changes to the environment.  

# Modules
* Context  
```
source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Context"
```
Provides basic resources like resource group, log analytics workspace, network, etc.  

* Remote
```
source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Remote"
```
Connects to an AzDO project, creates a variable group and tfstate.  
It works together with the bootstrap scripts and AzDO pipeline in this, the top-level module.  

* Bastion
```
source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-Bastion"
```
Provides Bastion-related resources.  

* VM
```
source = "git::https://dev.azure.com/golive/CurtainWall/_git/Curtain-Wall-Module-VM"
```
Provides VM-related resources. Can be tailored to be a build agent or a jumpbox, for example.  


# Notes

Note the use of ```git config xxx.insteadof...``` in the CI pipeline to swap in credentials enabling Terraform to pull in a module from a remote repository.  

Example from ci-pipeline.yaml:  
``` bash
      git config --global url."https://pat:$AZDO_PERSONAL_ACCESS_TOKEN@dev.azure.com/RRBLUEALM".insteadOf "https://dev.azure.com/RRBLUEALM"
```