terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
    region = var.aws_region_123
    access_key = var.Access_key_ID
    secret_key = var.Secret_access_key
}
