output "eventhub_namespace_name" {
  value       = azurerm_eventhub_namespace.ehnamespace.name
  description = " The name of eventhub namespace"
}
