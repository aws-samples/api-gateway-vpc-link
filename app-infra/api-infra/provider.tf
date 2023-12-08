provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = lower(var.environment)
      App         = var.app
      App_Owner   = var.app_owner
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
  backend "s3" {
    bucket = "umair-test-buck1"
    key    = "state-file-app-infra/state.tfstate"
    region = "us-east-1"
  }
}
