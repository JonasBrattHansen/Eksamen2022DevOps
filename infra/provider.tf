terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }

  backend "s3" {
      bucket = "pgr301-2021-terraform-state"
      key    = "glenn.richard.bech/apprunner-a-new-state.state"
      region = "eu-north-1"
    }
}