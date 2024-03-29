

variable "resource_group_name" {
  type = string
}

variable "region" {
  type = string
}

variable "label" {
  type = string
}

variable "vnet_cidr" {
  type    = string
  default = "192.168.0.0/20"
}

variable "subnet_cidrs" {
  default = ["192.168.0.0/22"]
}

variable "allow_public" {
  type    = string
  default = false
}

variable "external_ip" {
  default = null # defaults to workstation's public IP address 
  type    = string
}

variable "cluster_manager_vm_size" {
  type        = string
  default     = "Standard_DS2_v2"
  description = "The cluster manager instance size"
}


variable "network_type" {
  type    = string
  default = "create"

  validation {
    condition     = var.network_type == "create" || var.network_type == "load"
    error_message = "${var.network_type} not valid. Type must be either create or load"
  }
}

variable "virtual_network_name" {
  default = null
  type    = string
}

variable "virtual_subnet_name" {
  default = null
  type    = string
}


