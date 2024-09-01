# Create lambda function using a locally sourced zip file
resource "aws_lambda_function" "workout_odyssey_ping" {
  function_name = "workout-odyssey-ping"
  role          = aws_iam_role.wo_ping_lambda_role.arn
  package_type  = "Zip"
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  filename         = "function.zip"
  source_code_hash = filebase64sha256("function.zip")

  depends_on = [
    aws_iam_role.wo_ping_lambda_role
  ]

  tags = {
    Name = "Workout Odyssey ping"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_split_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.workout_odyssey_ping.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_5_minutes.arn
}
