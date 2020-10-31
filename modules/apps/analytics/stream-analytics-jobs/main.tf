# Azure Streaming Analytics Job
resource "azurerm_stream_analytics_job" "sajob" {
  name                                     = "${var.cluster_name}-sa-job"
  resource_group_name                      = var.resource_group_name
  location                                 = var.resource_group_location
  compatibility_level                      = "1.1"
  data_locale                              = "en-GB"
  events_late_arrival_max_delay_in_seconds = 60
  events_out_of_order_max_delay_in_seconds = 50
  events_out_of_order_policy               = "Adjust"
  output_error_policy                      = "Drop"
  streaming_units                          = 1

  tags = {
    cluster = var.cluster_name
    group   = var.tag_group_name
    env     = var.tag_env_name
  }

  transformation_query = <<QUERY
SELECT I1.date_time,I1.license_nbr,I1.fasttag_id,I1.track_nbr,I1.entry_type,R2.first_name,R2.last_name,R2.bank_name,R2.status,R1.reg_date,R1.exp_date, datediff(day, I1.EventProcessedUtcTime, R1.exp_date) as days
INTO "${var.cluster_name}-output1-to-blob"
FROM "${var.cluster_name}-input-from-eventhub" I1
LEFT JOIN "${var.cluster_name}-reference-input1-from-blob" R1
on I1.license_nbr = R1.license_nbr 
LEFT JOIN "${var.cluster_name}-reference-input2-from-blob" R2
on I1.fasttag_id = R2.fasttag_id
where datediff(day, I1.EventProcessedUtcTime, R1.exp_date) > 0 and datediff(day, I1.EventProcessedUtcTime, R1.exp_date) IS NOT Null

SELECT I1.date_time,I1.license_nbr,I1.fasttag_id,I1.track_nbr,I1.entry_type,R2.first_name,R2.last_name,R2.bank_name,R2.status,R1.reg_date,R1.exp_date, datediff(day, I1.EventProcessedUtcTime, R1.exp_date) as days
INTO "${var.cluster_name}-output2-to-blob"
FROM "${var.cluster_name}-input-from-eventhub" I1
LEFT JOIN "${var.cluster_name}-reference-input1-from-blob" R1
on I1.license_nbr = R1.license_nbr 
LEFT JOIN "${var.cluster_name}-reference-input2-from-blob" R2
on I1.fasttag_id = R2.fasttag_id
where datediff(day, I1.EventProcessedUtcTime, R1.exp_date) < 1 or datediff(day, I1.EventProcessedUtcTime, R1.exp_date) IS Null

SELECT I1.date_time,I1.license_nbr,I1.fasttag_id,I1.track_nbr,I1.entry_type,R2.first_name,R2.last_name,R2.bank_name,R2.status,R1.reg_date,R1.exp_date, datediff(day, I1.EventProcessedUtcTime, R1.exp_date) as days
INTO "${var.cluster_name}-output3-to-blob"
FROM "${var.cluster_name}-input-from-eventhub" I1
LEFT JOIN "${var.cluster_name}-reference-input1-from-blob" R1
on I1.license_nbr = R1.license_nbr 
LEFT JOIN "${var.cluster_name}-reference-input2-from-blob" R2
on I1.fasttag_id = R2.fasttag_id
where R2.status = 'Inactive' or R2.status IS Null
QUERY

}

# Azure Stream Analytics Job Input EventHub
resource "azurerm_stream_analytics_stream_input_eventhub" "sainputeh" {
  name                         = "${var.cluster_name}-input-from-eventhub"
  stream_analytics_job_name    = azurerm_stream_analytics_job.sajob.name
  resource_group_name          = var.resource_group_name
  eventhub_consumer_group_name = var.eventhub_consumer_group_name
  eventhub_name                = var.eventhub_name
  servicebus_namespace         = var.servicebus_namespace
  shared_access_policy_key     = var.shared_access_policy_key
  shared_access_policy_name    = var.shared_access_policy_name

  serialization {
    type     = "Json"
    encoding = "UTF8"
  }
}

# Azure Stream Analytics Job Reference Blob Input 1
resource "azurerm_stream_analytics_reference_input_blob" "sareferenceinput1" {
  name                      = "${var.cluster_name}-reference-input1-from-blob"
  stream_analytics_job_name = azurerm_stream_analytics_job.sajob.name
  resource_group_name       = var.resource_group_name
  storage_account_name      = var.storage_account_name
  storage_account_key       = var.storage_account_key
  storage_container_name    = var.ref_storage_container_name
  path_pattern              = "vehicles/vehicle.csv"
  date_format               = "yyyy-MM-dd"
  time_format               = "HH"

  serialization {
    type            = "Csv"
    encoding        = "UTF8"
    field_delimiter = ","
  }
}

# Azure Stream Analytics Job Reference Blob Input 2
resource "azurerm_stream_analytics_reference_input_blob" "sareferenceinput2" {
  name                      = "${var.cluster_name}-reference-input2-from-blob"
  stream_analytics_job_name = azurerm_stream_analytics_job.sajob.name
  resource_group_name       = var.resource_group_name
  storage_account_name      = var.storage_account_name
  storage_account_key       = var.storage_account_key
  storage_container_name    = var.ref_storage_container_name
  path_pattern              = "fasttags/fasttag.csv"
  date_format               = "yyyy-MM-dd"
  time_format               = "HH"

  serialization {
    type            = "Csv"
    encoding        = "UTF8"
    field_delimiter = ","
  }
}

# Azure Stream Analytics Job Output Blob Storage
resource "azurerm_stream_analytics_output_blob" "saoutputblob1" {
  name                      = "${var.cluster_name}-output1-to-blob"
  stream_analytics_job_name = azurerm_stream_analytics_job.sajob.name
  resource_group_name       = var.resource_group_name
  storage_account_name      = var.storage_account_name
  storage_account_key       = var.storage_account_key
  storage_container_name    = var.out_storage_container_name
  path_pattern              = "vehicles/registered/{date}/{time}/"
  date_format               = "yyyy-MM-dd"
  time_format               = "HH"

  serialization {
    type            = "Csv"
    encoding        = "UTF8"
    field_delimiter = ","
  }
}

# Azure Stream Analytics Job Output Blob Storage
resource "azurerm_stream_analytics_output_blob" "saoutputblob2" {
  name                      = "${var.cluster_name}-output2-to-blob"
  stream_analytics_job_name = azurerm_stream_analytics_job.sajob.name
  resource_group_name       = var.resource_group_name
  storage_account_name      = var.storage_account_name
  storage_account_key       = var.storage_account_key
  storage_container_name    = var.out_storage_container_name
  path_pattern              = "vehicles/nonregistered/{date}/{time}/"
  date_format               = "yyyy-MM-dd"
  time_format               = "HH"

  serialization {
    type            = "Csv"
    encoding        = "UTF8"
    field_delimiter = ","
  }
}

# Azure Stream Analytics Job Output Blob Storage
resource "azurerm_stream_analytics_output_blob" "saoutputblob3" {
  name                      = "${var.cluster_name}-output3-to-blob"
  stream_analytics_job_name = azurerm_stream_analytics_job.sajob.name
  resource_group_name       = var.resource_group_name
  storage_account_name      = var.storage_account_name
  storage_account_key       = var.storage_account_key
  storage_container_name    = var.out_storage_container_name
  path_pattern              = "vehicles/inactivefasttags/{date}/{time}/"
  date_format               = "yyyy-MM-dd"
  time_format               = "HH"

  serialization {
    type            = "Csv"
    encoding        = "UTF8"
    field_delimiter = ","
  }
}
