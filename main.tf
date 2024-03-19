terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "Workloads-profile"
}

module "EKS" {
  source = "./resource_configuration/Workloads"
}

module "landing_zone" {
  source = "./resource_configuration/landing_zone"
}