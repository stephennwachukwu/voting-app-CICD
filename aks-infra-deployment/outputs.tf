# Root module - outputs.tf
output "resource_group_name" {
  value = module.resource_group.resource_group_name
}

output "kubernetes_cluster_name" {
  value = module.aks_cluster.cluster_name
}

output "kube_config" {
  value     = module.aks_cluster.kube_config_raw
  sensitive = true
}

output "host" {
  value     = module.aks_cluster.host
  sensitive = true
}


output "acr_registry_name" {
  value = module.container_registry.registry_name
}

output "acr_registry_url" {
  value = module.container_registry.registry_url
}

output "acr_admin_username" {
  value = module.container_registry.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value = module.container_registry.admin_password
  sensitive = true
}