# modules/aks_cluster/outputs.tf
output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "host" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.host
  sensitive = true
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "cluster_identity_principal_id" {
  description = "The principal ID of the system assigned identity of the AKS cluster"
  value       = var.use_managed_identity ? azurerm_kubernetes_cluster.aks.identity[0].principal_id : ""
}