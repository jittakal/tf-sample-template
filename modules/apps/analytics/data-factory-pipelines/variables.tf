variable "cluster_name" {
  type        = string
  description = "The name to use as a cluster name"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "The resource group location name or code"
}

variable "data_factory_name" {
  type        = string
  description = "The Data Factory Name"
}

variable "storage_account_name" {
  type        = string
  description = "The storage account name"
}

variable "storage_account_id" {
  type        = string
  description = "The storage account Id"
}

variable "storage_account_connection" {
  type        = string
  description = "The storage account connection string"
}

variable "input_storage_container_name" {
  type        = string
  description = "The storage account connection string"
}

variable "output_storage_container_name" {
  type        = string
  description = "The storage account connection string"
}

variable "mysql_server_name" {
  type        = string
  description = "MySQL database server name"
}

variable "mysql_admin_username" {
  type        = string
  default     = "myadmin"
  description = "Admin user name of mysql server"
}

variable "mysql_admin_password" {
  type        = string
  description = "Admin users password of mysql server"
}

variable "mysql_database_name" {
  type        = string
  default     = "vehiclesregdb"
  description = "Mysql server database name"
}

variable "dataset_table_name" {
  type        = string
  default     = "vehicle_registration_detail"
  description = "Table Name"
}

variable "tag_cluster_name" {
  type        = string
  description = "Tag cluster name"
}

variable "tag_group_name" {
  type        = string
  description = "Tag group name"
}

variable "tag_env_name" {
  type        = string
  description = "Tag environment name"
}
