#
# Generate names for singleton resources
#
resource "azurecaf_name" "generated" {

  for_each = var.singleton_resource_names

  name          = var.base_name
  resource_type = each.value.resource_type
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group.name
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_subnet" "subnet" {
  name                 = azurecaf_name.generated["subnet"].result
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.new_subnet_address_prefixes
}

resource "azurerm_network_security_group" "nsg" {
  # this name is formatted according to MS standard so policy will leave it be
  name                = "${var.vnet_name}-${azurerm_subnet.subnet.name}-nsg-${var.resource_group.location}"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
}

resource "azurerm_subnet_network_security_group_association" "subnetnsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_user_assigned_identity" "mi_aks" {
  name                = azurecaf_name.generated["mi_aks"].result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_role_assignment" "aks_cluster_admin_role" {
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azurerm_user_assigned_identity.mi_aks.principal_id
}

# This is the equivalent to az aks update ... --attach-acr
resource "azurerm_role_assignment" "aks_cluster_kubelet_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "main" {
  name = azurecaf_name.generated["aks"].result

  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  node_resource_group = azurecaf_name.generated["rg_aks_node"].result

  default_node_pool {
    name                = "default"
    min_count           = 5
    max_count           = 10
    node_count          = 5
    vm_size             = var.default_aks_pool_vm_sku
    vnet_subnet_id      = azurerm_subnet.subnet.id
    enable_auto_scaling = true
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi_aks.id]
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  dns_prefix = azurecaf_name.generated["aks"].result

  network_profile {
    network_plugin = "azure"
  }

  workload_autoscaler_profile {
    keda_enabled = true
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,

    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  for_each              = var.node_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  enable_auto_scaling   = each.value.enable_auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count

  lifecycle {
    ignore_changes = [
      vnet_subnet_id
    ]
  }
}

resource "helm_release" "cert_manager" {
  count            = var.install_cert_manager ? 1 : 0
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.11.0"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}

