
resource "aws_cloudwatch_event_rule" "terraform_changes_detector" {
  name                = "${local.name_prefix}-terraform-changes-detector"
  description         = "A CloudWatch Event Rule scheduled on Sunday to dectect changes between current infra with terraform source code."
  is_enabled          = true
  role_arn            = aws_iam_role.terraform.arn
  schedule_expression = var.terraform_changes_detector_cron

  tags                = local.common_tags
}

resource "aws_cloudwatch_event_target" "terraform_changes_detector" {
  rule      = aws_cloudwatch_event_rule.terraform_changes_detector.name
  target_id = "${local.name_prefix}-terraform-changes-detector"
  arn       = module.codebuild_terraform.codebuild_project_arn
  role_arn  = aws_iam_role.terraform.arn
  input     = <<EOF
{
  "environmentVariablesOverride": [
    {
      "name": "AUTO_RUN",
      "value": "plan"
    },
    {
      "name": "BRANCH_NAME",
      "value": "devops"
    },
    {
      "name": "LAMBDA_INVOKE",
      "value": "true"
    }
  ]
}
EOF
}



