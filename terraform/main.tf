terraform {
  required_version = ">= 0.15.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "ejjunior"
    key    = "terraform"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}