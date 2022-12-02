resource "aws_s3_bucket" "analyticsbucket" {
  bucket = "analytics-${var.candidate_id}"
}
    resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
      bucket = aws_s3_bucket.analytics-1029.bucket
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm     = "AES256"
        }
      }
    }

