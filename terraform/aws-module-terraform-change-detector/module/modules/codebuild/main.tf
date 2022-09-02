################################
####### CodeBuild Module #######
################################

## AWS CodeBuild Project
resource "aws_codebuild_project" "this" {
    name            = "${local.name_prefix}-${var.codebuild_service_name}"
    description     = "CodeBuild for ${var.codebuild_service_name}"
    build_timeout   = var.codebuild_timeout
    service_role    = var.codebuild_service_role_arn
    source_version  = var.codebuild_source_branch
    artifacts {
        # type        = "NO_ARTIFACTS"
        type        = var.codebuild_artifact_type
    }

    environment {
        compute_type                = var.codebuild_environment_compute_type
        image                       = var.codebuild_environment_image
        type                        = var.codebuild_environment_type
        image_pull_credentials_type = var.codebuild_environment_image_pull_credentials_type
        privileged_mode             = var.codebuild_environment_privileged_mode

        dynamic "environment_variable" {
            for_each = merge(local.codebuild_environment, var.codebuild_extra_environment)
            content {
                name  = environment_variable.value.name
                value = environment_variable.value.value
                type  = environment_variable.value.type
            }
        }
    }

    source {
        type                = var.codebuild_source_type
        location            = var.codebuild_source_location
        # git_clone_depth     = var.codebuild_source_git_clone_depth
        buildspec           = var.codebuild_source_buildspec
        # git_submodules_config {
        #     fetch_submodules    = true
        # }
    }

    tags = local.common_tags
}

resource "aws_codebuild_webhook" "this" {
    count           = var.create_codebuild_webhook ? 1 : 0
    project_name    = aws_codebuild_project.this.name
    # url             = aws_codebuild_webhook.this.payload_url
    filter_group {
        dynamic "filter" {
            for_each    = var.codebuild_webhook_filter_list
            content {
                type    = filter.value.type
                pattern = filter.value.pattern
            }
        }
    }
}
resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/codebuild/${local.name_prefix}-${var.codebuild_service_name}"
  retention_in_days = var.retention_in_days
  tags = var.tags
}