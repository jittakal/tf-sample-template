variable "storage_account_name" {
  type        = string
  description = "Storage account name"
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
