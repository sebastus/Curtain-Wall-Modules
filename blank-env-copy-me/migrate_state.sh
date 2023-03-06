#!/usr/bin/env bash

export ARM_STATE_CONTAINER_NAME=$(terraform output -json rg_hub | jq -r '.state_container_name')
export ARM_STATE_RG_NAME=$(terraform output -json rg_hub | jq -r '.state_rg_name')
export ARM_STATE_STORAGE_NAME=$(terraform output -json rg_hub | jq -r '.state_storage_name')
export ARM_STATE_STORAGE_KEY=$(terraform output -json rg_hub | jq -r '.state_key')

rm dev_override.tf

terraform init -backend-config="storage_account_name=$ARM_STATE_STORAGE_NAME" -backend-config="container_name=$ARM_STATE_CONTAINER_NAME" -backend-config="key=$ARM_STATE_STORAGE_KEY" -backend-config="resource_group_name=$ARM_STATE_RG_NAME" -migrate-state
