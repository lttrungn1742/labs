data "aws_caller_identity" "current" {}

resource "aws_iam_role" "terraform_changes_detector" {
  name = "${var.project}-${var.environment}-lambda-terraform-changes-detector"

  force_detach_policies = true
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "terraform_changes_detector" {
  role = aws_iam_role.terraform_changes_detector.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy" "terraform_changes_detector" {
  role   = aws_iam_role.terraform_changes_detector.id
  name   = "${var.project}-${var.environment}-lambda-terraform-changes-detector"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "s3:GetObject",
          "s3:ListObject",
          "s3:ListBucket",
          "s3:GetObjectVersion"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
          "ssm:GetParameters",
          "ssm:GetParameter"
      ],
      "Resource": "arn:aws:ssm:ap-northeast-1:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/SLACK_TOKEN",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "terraform_changes_detector" {
  filename = var.lambda_file_path
  source_code_hash = filebase64sha256(var.lambda_file_path)
  function_name = "${var.project}-${var.environment}-lambda-terraform-changes-detector"
  role = aws_iam_role.terraform_changes_detector.arn
  handler = var.lambda_handler
  tags = var.tags
  runtime = var.python_runtime
  timeout = 10
  environment {
    variables = var.lambda_environments
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.project}-${var.environment}-lambda-terraform-changes-detector"
  retention_in_days = var.retention_in_days
  tags = {
    Environment = var.environment
    Application = "Terraform-change-detctor"
  }
}