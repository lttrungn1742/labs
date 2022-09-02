locals {
    common_tags = {
        "Manage_by"     = "Terraform"
        "Project"       = var.project_name
        "Environment"   = var.env
    }

    name_prefix = "${var.project_name}-${var.env}"
}

locals {
    codebuild_environment = {
        "BUILD_ENV" = {
            "name"  = "BUILD_ENV"
            "value" = var.env
            "type"  = "PLAINTEXT"
        }
        "CODEPIPELINE_S3" = {
            "name"  = "CODEPIPELINE_S3"
            "value" = "${local.name_prefix}-codepipeline"
            "type"  = "PLAINTEXT"
        }
        "GITHUB_TOKEN" = {
            "name"  = "GITHUB_TOKEN"
            "value" = var.codebuild_github_token_name
            "type"  = "PARAMETER_STORE"
        }
        "PROJECT" = {
            "name"   = "PROJECT"
            "value"  = var.project_name
            "type"   = "PLAINTEXT"      
        }
        "LOG_GROUP_NAME" = {
            "name"   = "LOG_GROUP_NAME"
            "value"  = "/aws/codebuild/${var.project_name}-${var.env}-terraform"
            "type"   = "PLAINTEXT"
        }
    }
}