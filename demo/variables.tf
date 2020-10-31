variable "cluster_name" {
  type        = string
  description = "The name to use as a cluster name"

  validation {
    condition     = lenght(var.cluster_name) < 5 && can(regex("/[^a-z]+/", var.cluster_name))
    error_message = "Cluster name must be lower case and upto only four characters string"
  }
}

# Resource Group
variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Resource Group Loacation"
}

# Storage Account
variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "Storage Account Tier"
}

variable "storage_account_replication_type" {
  type       = string
  default    = "LRS"
  decription = "Storage account replication type"
}

variable "storage_hrs_enabled" {
  type        = bool
  default     = true
  description = "Is hierarchy enabled"
}

# Event Hub
variable "eventhub_ns_capacity" {
  type        = number
  default     = 1
  description = "SKU Capacity"
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
