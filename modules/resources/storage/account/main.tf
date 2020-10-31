# Storage Account
resource "azurerm_storage_account" "saccount" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  is_hns_enabled           = var.storage_hrs_enabled

  tags = {
    cluster = var.tag_cluster_name
    group   = var.tag_group_name
    env     = var.tag_env_name
  }
}
