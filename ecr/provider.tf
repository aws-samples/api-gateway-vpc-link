provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      App_Owner   = var.app_owner
    }
  }
}
terraform {
  backend "s3" {
    bucket = "umair-test-buck1"
    key    = "state-file-ecr/state.tfstate"
    region = "us-east-1"
  }
}