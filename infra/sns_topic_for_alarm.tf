resource "aws_sns_topic" "alarms" {
  name = "alarm-topic-${var.candidate_id}"
}