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


resource "azurerm_resource_group" "cod-network" {
  name     = var.resource_group_name
  location = var.region
}


module "networking" {
  depends_on          = [azurerm_resource_group.cod-network]
  source              = "app.terraform.io/indico/indico-azure-network/mod"
  version             = "4.0.1"
  network_type        = "create"
  label               = var.label
  vnet_cidr           = var.vnet_cidr
  subnet_cidrs        = var.subnet_cidrs
  resource_group_name = var.resource_group_name
  region              = var.region
  allow_public        = var.allow_public
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
