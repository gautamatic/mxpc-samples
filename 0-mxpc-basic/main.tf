terraform {
  required_providers {
    azurerm = {
      source    = "hashicorp/azurerm"
      version   = "=2.46.0"
    }
  }
}

resource "random_string" "randomizer" {
    special     = false
    number      = false
    upper       = false
    length      = 8
}

provider "azurerm" {
  features {}
}

locals {
    namer           = var.prefix
    dust            = lower(random_string.randomizer.result)
}

resource "azurerm_resource_group" "rg" {
    name        = "resourcegroup-${var.prefix}"
    location    = var.location
    tags        = {mxref = var.prefix}
}

resource "azurerm_virtual_network" "vnet" {
  name                  = "${local.namer}-vnet"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  address_space         = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "subnet" {
  name                  = "${local.namer}-subnet"
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = ["10.1.0.0/16"]
}


# ------------------------------------------------------------------------
# AKS
# ------------------------------------------------------------------------
data "azurerm_kubernetes_service_versions" "current" {
  location  = var.location
}

resource "azurerm_kubernetes_cluster" "k8cluster" {
    name                    = "${local.namer}-aks"
    location                = azurerm_resource_group.rg.location
    resource_group_name     = azurerm_resource_group.rg.name
    kubernetes_version      = data.azurerm_kubernetes_service_versions.current.latest_version
    dns_prefix              = "${var.prefix}-k8s"

    default_node_pool {
        name            = "aksnodepool"
        node_count      = var.aksnodecount
        vm_size         = var.aksvmsize
        vnet_subnet_id  = azurerm_subnet.subnet.id
    }

    service_principal {
        client_id       = var.principalAppId
        client_secret   = var.principalAppSecret
    }

    tags = {mxref = var.prefix}
}


# ------------------------------------------------------------------------
# DATABASE
# ------------------------------------------------------------------------
resource "azurerm_sql_server" "db" {
  name                                          = "${local.namer}${local.dust}"
  resource_group_name                           = azurerm_resource_group.rg.name
  location                                      = azurerm_resource_group.rg.location
  version                                       = "12.0"
  administrator_login                           = var.mssqlserveradmin_username
  administrator_login_password                  = var.mssqlserveradmin_password
  tags                                          = {mxref = var.prefix}
}


# ------------------------------------------------------------------------
# STORAGE
# ------------------------------------------------------------------------
resource "azurerm_storage_account" "storage" {
  name                     = "${local.namer}${local.dust}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = {mxref = var.prefix}
}


# ------------------------------------------------------------------------
# CONTAINER REGISTRY
# ------------------------------------------------------------------------
resource "azurerm_container_registry" "acr" {
  name                     = "${local.namer}acr"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = true
  tags                     = {mxref = var.prefix}
}