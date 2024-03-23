terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
  profile = "Workloads-profile"
}

module "landing_zone" {
  source = "../landing_zone"
}