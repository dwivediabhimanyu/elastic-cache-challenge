terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.47.0"
    }
  }
}

# TODO1: Update IAM Credentials here 
provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}
