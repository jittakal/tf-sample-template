output "stream_analytics_job_name" {
  value       = azurerm_stream_analytics_job.sajob.name
  description = " The name of Event Hub"
}
