# Curtain Wall: DevSecOps In A Box
Curtain Wall is a system of tooling for AzDO/Azure projects.  

It is:  
* A DevSecOps system for AzDO/Azure.  
* A collection of Terraform modules  
* Installed in its own VNET/Subnet or existing.  
* Provided with an optional Bastion, if needed.  

## Getting Started
To install, make a copy of sample.tfvars and tailor to your environment.  
Login to az cli:  
- az login -t \<your Azure AD tenant id\>  
- az account set -s \<your Azure subscription id or name\>  

The simplest approach is to run tf init/plan/apply locally and keep state local. The alternative is to use the bootstrap script. It will install everything locally and then migrate tfstate to a remote backend. From that point on use the included AzDO pipeline to make changes to the environment.  

## Global tfvars file
A global tf vars file is needed for a few values. This is over and above the tfvars files described in the module readmes.  Here's the sample:  
```terraform
# ####################
# global
# ####################
location      = "westeurope"
azdo_org_name = "golive"
azdo_pat      = "personal access token"
```

## Modules
* Resource Group
Encapsulates the Context and Remote modules. Allows for creation of multiple resource groups, each of which can contain other resources like VMs, NICs, etc.  
Each resource group module instance needs its own set of variables and tfvars and optionally outputs. Examples are in the readme's of the various modules.  

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

Note the use of ```git config <pat substitution>.insteadof...``` in the CI pipeline to swap in credentials enabling Terraform to pull in a module from a remote repository.  

Example from ci-pipeline.yaml:  
``` bash
      git config --global url."https://pat:$AZDO_PERSONAL_ACCESS_TOKEN@dev.azure.com/RRBLUEALM".insteadOf "https://dev.azure.com/RRBLUEALM"
```
