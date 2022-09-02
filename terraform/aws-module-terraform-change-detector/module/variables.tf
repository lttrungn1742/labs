variable "enable_terraform_change_detector" {
  type = bool
  default = true
}
# lambda variable

variable "tags" {}
variable "project_name" {}
variable "env" {}
variable "name_prefix" {}
variable "aws_region" {}
variable lambda_entrypoint { default = "main.lambda_handler" }

variable "lambda_handler" {default = "main.lambda_handler"}
variable "lambda_environments" {}
variable "python_runtime" {}


variable "codebuild_terraform_environment" {
  default = {
    "AUTO_RUN" = {
      "name"  = "AUTO_RUN"
      "value" = "plan"
      "type"  = "PLAINTEXT"
    }
    "BRANCH_NAME" = {
      "name"  = "BRANCH_NAME"
      "value" = "devops"
      "type"  = "PLAINTEXT"
    }
    "LAMBDA_INVOKE" = {
      "name" : "LAMBDA_INVOKE",
      "value" : "true"
      "type" = "PLAINTEXT"
    }
    "LOG_GROUP_PERIOD"  = {
        "name"   = "LOG_GROUP_PERIOD"
        "value"  = "15m"
        "type"   = "PLAINTEXT"
    }
    "ENABLE_ALERT_ERROR_LOG"  = {
        "name"   = "ENABLE_ALERT_ERROR_LOG"
        "value"  = "yes"
        "type"   = "PLAINTEXT"
    }
    
    "REGION" = {
        "name"   = "REGION"
        "value"  = "ap-northeast-1"
        "type"   = "PLAINTEXT"      
    }
    "COUNT_CHARACTER" = {
        "name"   = "COUNT_CHARACTER"
        "value"  = "3000"
        "type"   = "PLAINTEXT"      
    }
  }
}

variable "codebuild_terraform_branch" { default = "devops" }
variable "codebuild_source_location" {  }
variable "codebuild_source_git_clone_depth" { default = 1 }
variable "codebuild_ci_buildspec" { default = "buildspec.yml" }
variable "codebuild_cd_buildspec" { default = "buildspec.yml" }
variable "codebuild_source_buildspec" { default = "buildspec.yml" }
variable "codebuild_bsc_price_bot_buildspec" { default = "buildspec_bsc_price_bot.yml" }
variable codebuild_artifact_type { default = "CODEPIPELINE" }
variable codebuild_source_type { default = "CODEPIPELINE"}

# Cloudwatch event settings
variable terraform_changes_detector_cron { default = "cron(0 15 ? * SAT *)" }


#Lambda settings
variable "lambda_file_name" {
  type = string
  default = "notifyTerraformChanged.zip"
}
variable "lambda_folder" {
  type = string
  default = "lambda_src"
}

variable "retention_in_days" {
  type = number
  default = 30
}

#codebuild setting
variable ssm_github_token_parameter_name {
    type = string
    default = "GITHUB_TOKEN"
}

variable "build_detector_version" {
  default = "v0.0.1"
}

variable "build_command_options" {
  default = "  "
}

variable "install_command_options" {
  default = "  "
}

variable "pre_build_command_options" {
  default = "  "
}

variable "post_build_command_options" {
  default = "  "
}

variable "script_name" {
  default = "build.sh"
}