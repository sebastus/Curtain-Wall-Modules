# What is Curtain Wall?

Curtain Wall is a lightweight framework produced by Microsoft for provisioning resources in Azure with Terraform. It focuses on the provisioning of private self-managed Azure resources for the creation of DevSecOps platforms and work-flows. It is comprised of a set of reusable Terraform modules designed to be used together, that stand-up different services and capabilities, and helps integrate them with Azure DevOps.

Curtain Wall is intended to make it easy to on-board new users to working with Terraform rather than abstracting them away from it. The modular service-oriented structure enables software factory infrastructure designs to be modelled in terms of their architecture, rather than at a low level. The modules provide a simple common interface for provisioning resources and services, and help ensure required security and operations tooling are consistently and correctly installed and configured. The modules can be stored remotely in Git and reused by multiple Terraform configurations.

# How to get started

First you need to set up a new Terraform environment. Use the module `blank-env-copy-me` for this in the following way:

1. Install pre-requisites
   To do this, run: 
   
   `pip install -r codegen/requirements.txt`

2. Copy/paste the template folder and rename it to the new environment name.
   In powershell, this is: 
   
   `Copy-Item .\blank-env-copy-me\ c:\whatever\newenv -Recurse`
   
   In this new environment folder you should see the following files:
   - .azdo/ci-pipeline.yaml
   - .gitignore
   - dev_override.tf
   - migrate_state.ps1
   - migrate_stash.sh
   - README.md
   - terraform.tf
   - variables.tf

3. Set your environment variables:

```pwsh
$env:CURTAIN_WALL_MODULES_HOME = "C:\{path}\Curtain-Wall-Modules"
$env:CURTAIN_WALL_ENVIRONMENT = "C:\Users\{user}\{path for wherever your new environment is}"
$env:CURTAIN_WALL_BACKEND_KEY = "example"
```

4. At the Curtain Wall Modules level run:

`python codegen/src/codegen.py create -g {resource group name}`

This will add config and terraform files to your environment needed for the base layer of Curtain Wall.

You can then add other modules to your environment with the command:

`python codegen/src/codegen.py add -m {module you want to add} -g {resource group name}`


5. Confirm the values in the dev.tfvars and .env/.env.ps1 for this new environment to reflect your azdo org and secrets.


# Running the Terraform

Change the appropriate variables in your tfvars file to reflect your azdo org and connections etc.

Then run:

```pwsh
terraform init
terraform plan -var-file=dev.tfvars -out my.tfplan
terraform apply my.tfplan
``` 

Running these three commands should populate your Azure Portal with a resource group containing:

- Key vault
- Log analytics workspace
- Managed identity
- Virtual networks
- Network security groups
- Network interface
- Disk
 
 and the modules you added.

# Architecture of environment built from Curtain Wall

Inside your selected environment Curtain Wall can create one or more trust groups. These function like resource groups in Azure, but come with a set of resources that you define in your dev.tfvars, eg. Managed Identity, Key Vault.

In each of these trust groups you can add any number of resources offered by the Curtain Wall modules, eg. AKS, Bastion.

Below are examples of two trust groups inside a resource. The resources brought in by the other Curtain Wall modules are set by you.

![Diagram of environment created by Curtain Wall](./images/EnvArch.png)