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
