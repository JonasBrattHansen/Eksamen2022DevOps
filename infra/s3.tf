
resource "aws_s3_bucket_server_side_encryption_configuration" "example4exam" {
  bucket = aws_s3_bucket.analyticsbucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

variable "bucket_name" {
  type = string
  default = "analytics-1029"
}