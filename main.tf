terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}

module "compute" {
 source = "./_modules/compute"
}

module "S3" {
 source = "./_modules/s3"
}
