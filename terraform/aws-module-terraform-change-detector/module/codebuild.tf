resource "aws_iam_role_policy" "terraform" {
  role       = aws_iam_role.terraform.name
  name       = "${local.name_prefix}-policy-terraform"
  depends_on = [aws_iam_role.terraform]
  policy     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject",
        "lambda:InvokeFunction",
        "lambda:ListFunctions",
        "codebuild:StartBuild"
      ],
      "Resource": "*",
      "Condition": {
        "ArnLike": {
          "aws:PrincipalArn": [
            "${aws_iam_role.terraform.arn}"
          ]
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "terraform" {
  role       = aws_iam_role.terraform.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role" "terraform" {
  name = "${local.name_prefix}-role-codebuild-terraform"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["codebuild.amazonaws.com", "events.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
# Recheck terraform planning weekly
data "aws_ssm_parameter" "github_token" {
  name = var.ssm_github_token_parameter_name
}

data "template_file" "buildspec" {
  template      = file("${path.module}/modules/codebuild/buildspec.yml")
  vars = {
    build_detector_version      = var.build_detector_version
    script_name                 = var.script_name
    build_command_options       = var.build_command_options
    post_build_command_options  = var.post_build_command_options
    pre_build_command_options   = var.pre_build_command_options
    install_command_options     = var.install_command_options
  }
}

module codebuild_terraform {
  source                           = "./modules/codebuild"
  tags                             = var.tags
  project_name                     = var.project_name
  env                              = var.env
  codebuild_service_name           = "terraform"
  codebuild_service_role_arn       = aws_iam_role.terraform.arn
  codebuild_timeout                = 15
  retention_in_days                = var.retention_in_days
  codebuild_extra_environment      = var.codebuild_terraform_environment
  codebuild_source_location        = var.codebuild_source_location
  codebuild_source_git_clone_depth = var.codebuild_source_git_clone_depth
  codebuild_source_buildspec       = data.template_file.buildspec.rendered
  codebuild_github_token_name      = data.aws_ssm_parameter.github_token.name
  create_codebuild_webhook         = false
  codebuild_source_branch          = var.codebuild_terraform_branch
}
