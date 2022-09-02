variable "tags" {}
variable "project" {}
variable "environment" {}
variable "region" {}
variable "lambda_file_path" {}
variable "lambda_handler" {default = "main.lambda_handler"}
variable "lambda_environments" {}
variable "python_runtime" {}
variable "retention_in_days" {}