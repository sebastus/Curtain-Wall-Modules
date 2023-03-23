Use this folder as a template for a new environment. An environment equals a tfstate instance.

To use:

1. Copy/paste the template folder and rename it to the new environment name.
   In powershell, this is: 
   
   `Copy-Item .\blank-env-copy-me\ c:\whatever\newenv -Recurse`
   
2. Confirm the values in the dev.tfvars for this new environment.

For more information see the main project README.md.
