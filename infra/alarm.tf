
resource "aws_cloudwatch_metric_alarm" "zerosum" {
  alarm_name                = "carts-over-5-1029"
  namespace                 = "1029"
  metric_name               = "carts_count.value"

  comparison_operator       = "GreaterThanThreshold"
  threshold                 = "5"
  evaluation_periods        = "3"
  period                    = "10"

  statistic                 = "Maximum"

  alarm_description         = "This alarm goes off if number of carts over three repeatedly periods on 5 minutes exceeds 5 "
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.user_updates.arn]
}

resource "aws_sns_topic" "user_updates" {
  name = "alarm-topic-${var.candidate_id}"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = "joha062@student.kristiania.no"
}