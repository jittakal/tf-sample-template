# Terraform required version
terraform {
  required_version = ">=0.13"
}

# Configure Terraform Provider
provider "azurerm" {
  version = "=2.23.0"
  features {}
}
