terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.43.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
#  profile = "Workloads-profile"
}

module "EKS" {
  source = "./resource_configuration/Workloads"
}

module "landing_zone" {
  source = "./resource_configuration/landing_zone"
}