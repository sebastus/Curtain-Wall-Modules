# bastion is used to connect to the build agent during development
create_bastion = false

# create a vnet or connect to an existing one
create_vnet               = false
existing_vnet_rg_name     = "some-rg"
existing_vnet_rg_location = "uksouth"
existing_vnet_name        = "some-vnet"

# create a subnet or connect to an existing one
create_subnet               = true
existing_subnet_id          = "/subscriptions/xxxxxxxxxxxxxxxxx/resourceGroups/some-rg/providers/Microsoft.Network/virtualNetworks/some-vnet/subnets/default"
new_subnet_address_prefixes = "10.0.0.128/26"

# AzDO details
azdo_org_name            = "myorg"
azdo_project_name        = "myproject"
azdo_pat                 = "gobbledegook"
azdo_pool_name           = "myPool"
azdo_build_agent_name    = "cw_infra_agent"
environment_demand_name  = "TestEnvironment"
azdo_variable_group_name = "TestEnvironment"
azdo_service_connection  = "myARMserviceConnection"

# how many build agents do you want?
count_of_agents = 2

