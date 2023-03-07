#!/usr/bin/env bash

TERRAFORM_OUTPUT="rg_hub"

echo "Run this code by dot sourcing it, i.e. '. ./migrate_state.sh'"
echo "Correct the name of the terraform output before continuing."
read -p "Press Enter to continue." </dev/tty

export ARM_STATE_CONTAINER_NAME=$(terraform output -json $TERRAFORM_OUTPUT | jq -r '.state_container_name')
export ARM_STATE_RG_NAME=$(terraform output -json $TERRAFORM_OUTPUT | jq -r '.state_rg_name')
export ARM_STATE_STORAGE_NAME=$(terraform output -json $TERRAFORM_OUTPUT | jq -r '.state_storage_name')
export ARM_STATE_STORAGE_KEY=$(terraform output -json $TERRAFORM_OUTPUT | jq -r '.state_key')

echo "Confirm the env vars are correct before continuing. There should be 8."
printenv | grep ARM
read -p "Press Enter to continue." </dev/tty

rm dev_override.tf

terraform init -backend-config="storage_account_name=$ARM_STATE_STORAGE_NAME" -backend-config="container_name=$ARM_STATE_CONTAINER_NAME" -backend-config="key=$ARM_STATE_STORAGE_KEY" -backend-config="resource_group_name=$ARM_STATE_RG_NAME" -migrate-state
