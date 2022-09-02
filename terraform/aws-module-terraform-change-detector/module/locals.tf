locals {
  common_tags = var.tags
  name_prefix      = var.name_prefix
  lambda_file_path = "${path.module}/${var.lambda_folder}/${var.lambda_file_name}"
}
