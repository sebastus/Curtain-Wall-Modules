Use this folder as a template for a new environment. An environment equals a tfstate instance.

To use:

1. Copy/paste the template folder and rename it to the new environment name.
   In powershell, this is: cp .\blank-env-copy-me c:\whatever\newenv -Recurse
   
2. Confirm the values in the terraform.tfvars for this new environment.

NOTE: ensure that terraform.tfvars in the new env is *not* committed to source control.
