$output = (terraform output -json rg_hub ) | convertfrom-json

$env:ARM_STATE_CONTAINER_NAME=$output.state_container_name
$env:ARM_STATE_RG_NAME=$output.state_rg_name
$env:ARM_STATE_STORAGE_NAME=$output.state_storage_name
$env:ARM_STATE_STORAGE_KEY=$output.state_key

az keyvault secret set --vault-name kv-go-temp --name ARM-STATE-RG-NAME --value $env:ARM_STATE_RG_NAME
az keyvault secret set --vault-name kv-go-temp --name ARM-STATE-STORAGE-NAME --value $env:ARM_STATE_STORAGE_NAME
az keyvault secret set --vault-name kv-go-temp --name ARM-STATE-CONTAINER-NAME --value $env:ARM_STATE_CONTAINER_NAME
az keyvault secret set --vault-name kv-go-temp --name ARM-STATE-STORAGE-KEY --value $env:ARM_STATE_STORAGE_KEY

Remove-Item -Path dev_override.tf -Force

terraform init -backend-config="storage_account_name=$env:ARM_STATE_STORAGE_NAME" -backend-config="container_name=$env:ARM_STATE_CONTAINER_NAME" -backend-config="key=$env:ARM_STATE_STORAGE_KEY" -backend-config="resource_group_name=$env:ARM_STATE_RG_NAME" -migrate-state
