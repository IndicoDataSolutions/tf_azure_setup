

output "cluster_manager_ip" {
  value = module.cluster-manager.cluster_manager_ip
}

output "private_key" {
  value     = tls_private_key.pk.private_key_pem
  sensitive = true
}

output "subnet_id" {
  value = module.networking.subnet_id
}

output "vnet_id" {
  value = module.networking.vnet_id
}

