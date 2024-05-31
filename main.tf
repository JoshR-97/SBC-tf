# Configure the Azure & random providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
  }
  backend "azurerm" {
      resource_group_name  = "terra"
      storage_account_name = "abc123"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "random" {  
}