terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    namecheap = {
      source = "namecheap/namecheap"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = var.shared_credentials_files
  profile                  = var.profile
}

# Namecheap API credentials
provider "namecheap" {
  user_name = var.user_name
  api_user  = var.api_user
  api_key   = var.api_key
}