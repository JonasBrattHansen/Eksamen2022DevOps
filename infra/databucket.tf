resource "aws_s3_bucket" "analyticsbucket" {
count= 4
  bucket = "analytics-${var.candidate_id}-${count.index}"
}

