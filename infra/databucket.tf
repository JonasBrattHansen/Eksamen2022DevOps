resource "aws_s3_bucket" "analyticsbucket" {
  bucket = "analytics-${var.candidate_id}"
}

/*
 "Effect" : "Allow",
  "Resource": "arn:aws:s3:::${var.candidate_id}/*",
  "Principal": "*"
*/
