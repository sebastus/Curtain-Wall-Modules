module "linux-vm" {
  source = "git::https://github.com/commercial-software-engineering/Curtain-Wall-Modules//linux-vm?ref=main"
  #source = "../Curtain-Wall-Modules/linux-vm"

  count            = var.xxx_count_of_vm
  instance_index   = count.index

  base_name        = var.xxx_linuxvm_base_name

  resource_group = module.tg_xxx.resource_group
  subnet_id      = module.tg_xxx.well_known_subnets["default"].id
  vm_size        = var.xxx_linuxvm_vm_size

  create_pip = var.xxx_linuxvm_create_pip

  # this is passed to the finally cipart so cloud init completion can be tagged
  managed_identity = module.tg_xxx.managed_identity

  # this is passed to the vm so user assigned identity can be assigned
  identity_ids   = [module.tg_xxx.managed_identity.id]

  include_azdo_ba         = var.xxx_include_azdo_ba
  azdo_pat                = var.azdo_pat
  azdo_org_name           = var.azdo_org_name
  azdo_agent_version      = var.xxx_azdo_agent_version
  environment_demand_name = var.xxx_azdo_environment_demand_name
  azdo_pool_name          = var.xxx_azdo_pool_name
  azdo_build_agent_name   = var.xxx_azdo_build_agent_name

  law_installed               = (module.tg_xxx.log_analytics_workspace != null)
  install_omsagent            = var.xxx_linuxvm_install_omsagent
  log_analytics_workspace_id  = (module.tg_xxx.log_analytics_workspace != null) ? module.tg_xxx.log_analytics_workspace.workspace_id : null
  log_analytics_workspace_key = (module.tg_xxx.log_analytics_workspace != null) ? module.tg_xxx.log_analytics_workspace.primary_shared_key : null

  include_terraform = var.xxx_include_terraform
  terraform_version = var.xxx_terraform_version

  include_openvpn          = var.xxx_include_openvpn
  storage_account_name     = var.xxx_storage_account_name

  include_sonarqube_server = var.xxx_include_sonarqube_server
  include_azcli            = var.xxx_include_azcli
  include_nexus            = var.xxx_include_nexus
  include_docker           = var.xxx_include_docker
  include_pwsh             = var.xxx_include_pwsh
  include_packer           = var.xxx_include_packer
  include_dotnetsdk        = var.xxx_include_dotnetsdk
  include_maven            = var.xxx_include_maven

  powershell_command       = "powershell"
}
