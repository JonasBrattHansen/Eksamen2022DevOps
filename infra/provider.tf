terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

resource "aws_s3_bucket" "analyticsbucket" {
  bucket = "analytics-${var.candidate_id}"
}

backend "s3" {
    bucket = "analyticsbucket"
    key    = "analyticsbucket.state"
    region = "eu-north-1"
}

variable "bucket_name" {
  type = string
}
