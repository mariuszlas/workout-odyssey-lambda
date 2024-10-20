# Store the AWS account_id in a variable so it can be refernceed it in IAM policy
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# Lambda IAM Role
resource "aws_iam_role" "wo_ping_lambda_role" {
  name = "workout-odyssey-ping-lambda-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })

  tags = {
    Terraform = "true"
  }
}

# IAM Policy to attach to IAM Lambda Role
resource "aws_iam_role_policy" "wo_ping_lambda_role_policy" {
  name = "wo_ping_lambda_role_policy"
  role = aws_iam_role.wo_ping_lambda_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/lambda/*:*"
        ]
      }
    ]
  })
}