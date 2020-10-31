# Azure MySQL Server
resource "azurerm_mysql_server" "mysqlserver" {
  name                = "${var.cluster_name}-mysqlserver"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  administrator_login          = var.mysql_admin_username
  administrator_login_password = var.mysql_admin_password

  sku_name   = "GP_Gen5_4"
  storage_mb = 10240
  version    = "5.7"

  auto_grow_enabled                 = false
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_1"
}

# Azure MySQL Server Database
resource "azurerm_mysql_database" "mysqldb" {
  name                = var.mysql_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
