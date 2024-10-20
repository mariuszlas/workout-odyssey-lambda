# Create zip file
data "archive_file" "function_zip_file" {
  type = "zip"

  source_file = "${path.module}/index.js"
  output_path = "${path.module}/function.zip"
}

# Create lambda function using a locally sourced zip file
resource "aws_lambda_function" "workout_odyssey_ping" {
  function_name = "workout-odyssey-ping"
  role          = aws_iam_role.wo_ping_lambda_role.arn
  package_type  = "Zip"
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  filename         = data.archive_file.function_zip_file.output_path
  source_code_hash = data.archive_file.function_zip_file.output_base64sha256

  depends_on = [
    aws_iam_role.wo_ping_lambda_role
  ]

  logging_config {
    log_format       = "JSON"
    log_group        = aws_cloudwatch_log_group.wo_ping_log.name
    system_log_level = "INFO"
  }

  tags = {
    Name      = "Workout Odyssey Ping"
    Terraform = "true"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_split_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.workout_odyssey_ping.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_5_minutes.arn
}

resource "aws_cloudwatch_log_group" "wo_ping_log" {
  name              = "/aws/lambda/workout-odyssey-ping"
  retention_in_days = 30

  tags = {
    Terraform = "true"
  }
}