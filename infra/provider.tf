terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
  backend "s3" {
      bucket = "analytics-${candidate_id}"
      key    = "analytics-${candidate_id}.state"
      region = "eu-north-1"
  }
}


