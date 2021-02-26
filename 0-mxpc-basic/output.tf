# database ------------------------
output "a1_mssql_database_url" {
    value = azurerm_sql_server.db.fully_qualified_domain_name
}
output "a2_mssqldb_username" {
    value = var.mssqlserveradmin_username
}
output "a3_mssqldb_password" {
    value = var.mssqlserveradmin_password
}


# storage ------------------------
output "b2_storage_endpoint" {
    value = azurerm_storage_account.storage.primary_blob_endpoint 
}


# registry --------------
output "c1_registry_url" {
    value = azurerm_container_registry.acr.login_server
}
output "c2_registry_username" {
    value = azurerm_container_registry.acr.admin_username
}
output "c3_registry_password" {
    value = azurerm_container_registry.acr.admin_password
}


# misc ------------------------
output "z1_get_credentials_for_your_k8scluster" {
    value = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.k8cluster.name}"
}
output "z2_set_your_context" {
    value = "kubectl config use-context ${azurerm_kubernetes_cluster.k8cluster.name}"
}
output "z3_connect_mendix_to_your_cluster" {
    value = "https://docs.mendix.com/developerportal/deploy/private-cloud-deploy"
}