terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
  backend "s3" {
      bucket = "analytics-1029"
      key    = "1029/eksamen.state"
      region = "eu-west-1"
    }
}





