function Migrate-State {

<#
.SYNOPSIS
    Adds tfstate backend secrets to provided key vault, executes a terraform init that migrates tfstate from local to that backend.

.DESCRIPTION
    Migrate-State gets the remote tfstate storage account details from the terraform output named by the rgname parameter. It stores those values in the provided key fault as secrets. It then executes terraform init to migrate the local tfstate to that remote storage.

.PARAMETER rgname
    The terraform output that contains the resource group module output data.

.PARAMETER kvname
    The name of an existing key vault to which the values will be added.

.EXAMPLE
     Migrate-State 'rg_xxx' 'kv-my-keyvault'

.EXAMPLE
     Migrate-State 'rg_bae_hub' 'kv-CRS-UKS-D-EAH'

.INPUTS
    String -rgname
    String -kvname

.OUTPUTS
    None

.NOTES
    To load Migrate-State into memory, dot source this file, e.g.
    . .\Migrate-State.ps1
    Then it can be run at the command line just like any other PowerShell function, but only during this session.
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $rgname,

        [Parameter(Mandatory=$true)]
        [string] $kvname
    )
    $output = (terraform output -json $rgname ) | convertfrom-json

    $env:ARM_STATE_CONTAINER_NAME=$output.state_container_name
    $env:ARM_STATE_RG_NAME=$output.state_rg_name
    $env:ARM_STATE_STORAGE_NAME=$output.state_storage_name
    $env:ARM_STATE_STORAGE_KEY=$output.state_key

    az keyvault secret set -o none --vault-name $kvname --name ARM-STATE-RG-NAME --value $env:ARM_STATE_RG_NAME
    az keyvault secret set -o none --vault-name $kvname --name ARM-STATE-STORAGE-NAME --value $env:ARM_STATE_STORAGE_NAME
    az keyvault secret set -o none --vault-name $kvname --name ARM-STATE-CONTAINER-NAME --value $env:ARM_STATE_CONTAINER_NAME
    az keyvault secret set -o none --vault-name $kvname --name ARM-STATE-STORAGE-KEY --value $env:ARM_STATE_STORAGE_KEY

    Remove-Item -Path dev_override.tf -Force

    terraform init `
        -backend-config="storage_account_name=$env:ARM_STATE_STORAGE_NAME" `
        -backend-config="container_name=$env:ARM_STATE_CONTAINER_NAME" `
        -backend-config="key=$env:ARM_STATE_STORAGE_KEY" `
        -backend-config="resource_group_name=$env:ARM_STATE_RG_NAME" `
        -migrate-state
}