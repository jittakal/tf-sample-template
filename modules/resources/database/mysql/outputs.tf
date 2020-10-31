output "mysql_server_name" {
  value       = azurerm_mysql_server.mysqlserver.name
  description = "The name of the MySQL server"
}
