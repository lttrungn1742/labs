# Lambda function to check terraform plan output for changes
module terraform_changes_detector_lambda {
  source = "./modules/lambda-notification"
  tags             = var.tags
  project          = var.project_name
  environment      = var.env
  region           = var.aws_region
  retention_in_days = var.retention_in_days
  lambda_file_path = local.lambda_file_path
  lambda_handler   = var.lambda_entrypoint
  python_runtime   = var.python_runtime
  lambda_environments = merge(var.lambda_environments,
    {
      "ENV"     = var.env
      "PROJECT" = var.project_name
    }
  )
}