terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "terraform-bucket-200926"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-table"   
  }
}

provider "aws" {
    region = "ap-south-1"
    access_key = var.Access_key_ID
    secret_key = var.Secret_access_key
}
