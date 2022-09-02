variable tags {}
variable project_name { default = "" }
variable env { default = "" }
variable aws_region { default = ""}
variable codebuild_service_name { default = "" }
variable codebuild_service_role_arn { default = "" }
variable codebuild_timeout { default = 10 }
variable codebuild_source_branch { default = ""}
# BUILD_GENERAL1_SMALL || BUILD_GENERAL1_MEDIUM || BUILD_GENERAL1_LARGE || BUILD_GENERAL1_2XLARGE || BUILD_GENERAL1_SMALL
# BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER
# When type is set to LINUX_GPU_CONTAINER, compute_type must be BUILD_GENERAL1_LARGE
variable codebuild_environment_compute_type { default = "BUILD_GENERAL1_SMALL" }    

variable codebuild_environment_image { default = "aws/codebuild/standard:5.0" }

# LINUX_CONTAINER || LINUX_GPU_CONTAINER || WINDOWS_CONTAINER || WINDOWS_SERVER_2019_CONTAINER || ARM_CONTAINER
variable codebuild_environment_type { default = "LINUX_CONTAINER" }

# CODEBUILD || SERVICE_ROLE
# Default: CODEBUILD
variable codebuild_environment_image_pull_credentials_type { default = "CODEBUILD" }

# Whether to enable running the Docker daemon inside a Docker container. Default: false
variable codebuild_environment_privileged_mode { default = true }

variable codebuild_extra_environment { default = {} }
# Example: 
# variable codebuild_extra_environment {
#     "ENVIRONMENT_1" = {
#         "name"  = "ENVIRONMENT_1"
#         "value" = "value_ENVIRONMENT_1"
#         "type"  = "PARAMETER_STORE" || "PLAINTEXT" || "SECRETS_MANAGER"
#     }
#     "ENVIRONMENT_2" = {
#         "name"  = "ENVIRONMENT_2"
#         "value" = "value_ENVIRONMENT_2"
#         "type"  = "PARAMETER_STORE" || "PLAINTEXT" || "SECRETS_MANAGER"
#     }
# }

# CODECOMMIT || CODEPIPELINE || GITHUB || GITHUB_ENTERPRISE || BITBUCKET || S3 || NO_SOURCE
variable codebuild_source_type { default = "GITHUB" }

# Location of the source code from git or s3
variable codebuild_source_location { default = "" }

# Truncate git history to this many commits. Use 0 for a Full checkout which you need to run commands like git branch --show-current.
variable codebuild_source_git_clone_depth { default = 1 }

variable codebuild_source_buildspec { default = "" }

variable codebuild_webhook_filter_list { default = {} }
# Example:
# variable codebuild_webhook_filter_list { 
#     default = {
#         "EVENT" = {
#             "type"      = "EVENT"
#             "pattern"   = ""      
#         }
#         "HEAD_REF" = {
#             "type"      = "HEAD_REF"
#             "pattern"   = ""
#         }
#         "BASE_REF" = {
#             "type"      = "BASE_REF"
#             "pattern"   = ""
#         }
#     }
# }
# 
# type - (Required): EVENT || BASE_REF || HEAD_REF || ACTOR_ACCOUNT_ID || FILE_PATH || COMMIT_MESSAGE .
# At least one filter group must specify EVENT as its type.
# 
# pattern - (Required): For a filter that uses EVENT type
# a comma-separated string that specifies one event: PUSH || PULL_REQUEST_CREATED || PULL_REQUEST_UPDATED || PULL_REQUEST_REOPENED. 
# PULL_REQUEST_MERGED works with GitHub & GitHub Enterprise only. For a filter that uses any of the other filter types, a regular expression.

variable codebuild_github_token_name { default = "" }
variable create_codebuild_webhook { default = false }
variable retention_in_days {}
variable codebuild_artifact_type { default = "NO_ARTIFACTS" }