resource "aws_cloudwatch_metric_alarm" "zerosum" {
  alarm_name                = "carts-over-5-1029"
  namespace                 = "joha062"
  metric_name               = "carts_count.value"

  comparison_operator       = "GreaterThanThreshold"
  threshold                 = "5"
  evaluation_periods        = "3"
  period                    = "300"

  statistic                 = "Maximum"

  alarm_description         = "This alarm goes off if number of carts over three repetedly periods on 5 minutes exceeds 5 "
  insufficient_data_actions = []
  alarm_actions       = [aws_sns_topic.user_updates.arn]
}