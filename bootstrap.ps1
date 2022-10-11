#!/usr/bin/env pwsh

param(
    [string]$tfvarsFilePath
)

if (-not(Test-Path -Path $tfvarsFilePath)) {
    Write-Host "ERROR: $tfvarsFilePath does not exist"
    exit 1
}

Write-Host "Setting up local terraform environment override"

$content=@'
terraform {
  backend "local" {
  }
}
'@
Set-Content -Path dev_override.tf -Value $content

Write-Host "Init terraform locally"
terraform init

Write-Host "Apply terraform locally"
terraform apply -var-file="$tfvarsFilePath" -var "install_remote=true"

$env:ARM_STATE_CONTAINER_NAME=$(terraform output state_container_name)
$env:ARM_STATE_RG_NAME=$(terraform output state_rg_name)
$env:ARM_STATE_STORAGE_NAME=$(terraform output state_storage_name)
$env:ARM_STATE_STORAGE_KEY=$(terraform output state_key)

Remove-Item -Path dev_override.tf -Force

terraform init -backend-config="storage_account_name=$env:ARM_STATE_STORAGE_NAME" -backend-config="container_name=$env:ARM_STATE_CONTAINER_NAME" -backend-config="key=$env:ARM_STATE_STORAGE_KEY" -backend-config="resource_group_name=$env:ARM_STATE_RG_NAME" -migrate-state

Write-Host "Done"
