# Create schedule
resource "aws_cloudwatch_event_rule" "every_5_minutes" {
  name                = "every-5-minutes"
  description         = "Fires every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

# Trigger lambda function based on the schedule
resource "aws_cloudwatch_event_target" "trigger_lambda_on_schedule" {
  rule      = aws_cloudwatch_event_rule.every_5_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.workout_odyssey_ping.arn
}
