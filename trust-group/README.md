# Overview

This module is the starting point for all Curtain Wall environments. So what is a trust-group (tg) anyway?  

A trust-group is a security and identity boundary established by a resource group, managed identity, virtual network and a key vault.  

There may be many trust-groups in an environment. They may all have a virtual network and those networks may be peered to another vnet. This is to say that hub-and-spoke networking is supported.  

The standard trust-group resources are as follows:

## Mandatory but may be ingested
* Resource group 
* User assigned managed identity 
* Key vault  
* Virtual network  
* Well known subnets* + associated NSG's  

## Optional
* Log analytics workspace  
* Azure Container Registry  
* Azure storage account for Terraform state  
* Key vault private endpoint  
* Key vault private DNS zone  
* Key vault private DNS virtual network link  
* Virtual Network peering  
* Popular private DNS zones  
* Bastion NSG's  
* OpenVPN network adjustments - e.g. NSG & Route table  

### *What are well known subnets?
default, AzureBastionSubnet and PrivateEndpointsSubnet. These are in trust-group because some customers disallow network modifications. But putting them in trust-group and providing the ability to ingest the resources, other modules downstream that need these network resources don't have to worry about it.  

Additional subnets can be added to the list in dev.tfvars quite easily.  

&nbsp;
# How to use with the Code Generator

At the Curtain Wall modules level, run

`python codegen/src/codegen.py create -g {trust group name}`

for example:

`python codegen/src/codegen.py create -g hub`  
`python codegen/src/codegen.py create -g joe`  
`python codegen/src/codegen.py create -g mary`  
`python codegen/src/codegen.py create -g TeamA`  

&nbsp;
# How to use with the Builder

The Builder is discussed in detail in the main repo [README.md](../README.md).

&nbsp;
# Execution requirements

The trust-group module has no special needs - it runs on Windows or Linux.  

&nbsp;
# Changes you need to make

The invoke script assumes that you have a subnet named "PrivateEndpointsSubnet". If you don't and you want the key vault private endpoint, plug the correct name into the script in your environment.

&nbsp;
# References to other module outputs

None.  

&nbsp;
# What does the module change

This module adds the following to your environment.

*.tfvars & vars files:*
```
{ tgname }_tg_base_name = "my-trust"

{ tgname }_create_resource_group        = true
{ tgname }_existing_resource_group_name = ""

{ tgname }_create_law = false

{ tgname }_create_managed_identity        = false
{ tgname }_existing_managed_identity_name = "mi-whatever"
{ tgname }_existing_managed_identity_rg   = "rg-somewhere"

{ tgname }_create_acr              = false
{ tgname }_create_kv               = true
{ tgname }_make_created_kv_private = false
{ tgname }_existing_kv_name        = ""
{ tgname }_existing_kv_rg_name     = ""

{ tgname }_create_platform_vpn = false

{ tgname }_create_vnet            = true
{ tgname }_new_vnet_address_space = "10.0.0.0/16"
{ tgname }_existing_vnet_rg_name  = ""
{ tgname }_existing_vnet_name     = ""
{ tgname }_peer_vnet_with_another = false

{ tgname }_create_well_known_subnets = true

{ tgname }_include_openvpn_mods    = false
{ tgname }_openvpn_client_cidr     = "10.8.0.0/16"
{ tgname }_openvpn_client_next_hop = "10.0.0.4"
{ tgname }_openvpn_is_in_this_tg   = false

{ tgname }_is_tfstate_home     = false
{ tgname }_tfstate_storage_key = "state"

# List of well known subnets with configuration
# Expressed as map of object
{ tgname }_well_known_subnets = {
  default = {
    address_prefix = "10.0.0.0/24"
  },
  AzureBastionSubnet = {
    address_prefix = "10.0.1.0/24"
  },
  PrivateEndpointsSubnet = {
    address_prefix = "10.0.2.0/24"
  }
}
```
*{tg name}.tf:* 
```
Terraform module "tg_{tg name}" 
```
*outputs.tf:*
```
module.tg_{tg name}
```