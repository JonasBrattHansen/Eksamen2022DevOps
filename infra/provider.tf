terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.39.0"
    }
  }

  backend "s3" {
    bucket = "1029"
    key    = "joha062/apprunner-a-new-state.state"
    region = "eu-east-2"
  }
}
