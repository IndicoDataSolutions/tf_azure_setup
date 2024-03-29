terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "http" {}

locals {
  resource_group_name = coalesce(var.resource_group_name, "${var.label}-${var.region}")
}

data "azurerm_resource_group" "loaded-group" {
  count = var.network_type == "create" ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "cod-network" {
  count    = var.network_type == "load" ? 0 : 1
  name     = var.resource_group_name
  location = var.region
}

module "networking" {
  depends_on           = [azurerm_resource_group.cod-network, data.azurerm_resource_group.loaded-group]
  source               = "app.terraform.io/indico/indico-azure-network/mod"
  version              = "4.0.1"
  network_type         = var.network_type
  label                = var.label
  vnet_cidr            = var.vnet_cidr
  subnet_cidrs         = var.subnet_cidrs
  resource_group_name  = local.resource_group_name
  region               = var.region
  allow_public         = var.allow_public
  virtual_network_name = var.virtual_network_name
  virtual_subnet_name  = var.virtual_subnet_name
}


data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
  external_ip   = coalesce(var.external_ip, local.external-cidr)
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


module "cluster-manager" {
  source  = "app.terraform.io/indico/indico-azure-cluster-manager/mod"
  version = "3.0.3"

  label = "${var.label}-dcm"

  subnet_id           = module.networking.subnet_id
  external_ip         = local.external_ip
  public_key          = tls_private_key.pk.public_key_openssh
  resource_group_name = var.resource_group_name
  region              = var.region
  vm_size             = var.cluster_manager_vm_size
  offer               = "0001-com-ubuntu-server-focal"
  publisher           = "Canonical"
  sku                 = "20_04-lts-gen2"
}
