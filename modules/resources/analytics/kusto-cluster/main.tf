# Azure Data Explorer Cluster
resource "azurerm_kusto_cluster" "cluster" {
  name                = var.kusto_cluster_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku {
    name = var.kusto_sku_name
  }

  optimized_auto_scale {
    minimum_instances = var.kusto_minimum_instances
    maximum_instances = var.kusto_maximum_instances
  }

  tags = {
    cluster = var.cluster_name
    group   = var.tag_group_name
    env     = var.tag_env_name
  }

}

# Create Database
resource "azurerm_kusto_database" "database" {
  name                = "demo-database"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  cluster_name        = azurerm_kusto_cluster.cluster.name

  hot_cache_period   = "P7D"
  soft_delete_period = "P31D"
}
