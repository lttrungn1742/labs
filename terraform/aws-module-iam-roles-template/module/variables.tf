variable admin_role_name {
  type        = string
  default     = "Admin"
}

variable aws_trusted_bastion_accts {
  type        = list
  description = "ARN AWS Account Trust"
}

variable developer_role_name {
  type        = string
  default     = "Developer"
}

variable proper_role_name {
  type        = string
  default     = "Proper"
}

variable readonly_role_name {
  type        = string
  default     = "Readonly"
}

variable developer_json_policy {
  type        = string
  default     = null
}

variable proper_json_policy {
  type        = string
  default     = null
}

variable admin_policy_arn {
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable readonly_policy_arn {
  type        = string
  default     = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

variable "deny_regions" {
  type =  list
  default = [
     "us-east-1",
     "us-east-2",
     "us-west-2",
     "us-west-1",
     "eu-west-1",
     "eu-central-1",
     "ap-southeast-1",
     "ap-southeast-2",
     "ap-northeast-2",
     "ap-south-1",
     "sa-east-1"
  ]
}

variable "tags" {
  default = { 
    "Manage_by"   = "Terraform"
  }
}