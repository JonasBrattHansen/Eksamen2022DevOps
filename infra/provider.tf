terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }


  backend "s3" {
      bucket = "analytics-1029"
      key    = "analytics-1029.state"
      region = "eu-west-1"
  }
}

  resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
    bucket = aws_s3_bucket.analytics-1029.bucket
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }


