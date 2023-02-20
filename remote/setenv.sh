#!/bin/bash

echo "##vso[task.setvariable variable=TF_VAR_azdo_org_name]${{ variables.azdo_org_name }}"
# echo "##vso[task.setvariable variable=TF_VAR_azdo_pat]${{ variables.azdo_pat }}"
