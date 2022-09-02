locals {
  common_tags = var.tags != null ? var.tags : {
    "Manage_by"   = "Terraform"
    "Project"     = var.project_name
    "Environment" = var.env
  }

  name_prefix = "${var.project_name}-${var.env}"

}
