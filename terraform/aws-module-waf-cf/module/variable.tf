variable "waf_rate_limit" {}

variable "waf_aws_manage_rule_group" {}

variable "prefix" {}

variable "waf_enable_cloudwatch_metric" {
  default = true
}

variable "waf_enable_sample_request" {
  default = true
}

variable "tags" {
  default = {}
}

# variable association_resource_arn {}

variable "s3_lifecycle" {
  default = [
    {
      days          = 30
      storage_class = "INTELLIGENT_TIERING"
    },
    {
      days          = 90
      storage_class = "GLACIER"
    },
    {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  ]
}

variable "s3_expiration" {
  default = 365
}

variable "cloudwatch_log_retention" {
  default = 365
}

variable "kinesis_buffer_size" {
  default = 1
}

variable "kinesis_buffer_interval" {
  default = 60
}

variable "external_rule_groups" {
  default = []
  // default = [
  //     ["name", "rule_group_arn'"]
  // ]
}

variable "allow_default_action" {
  type        = bool
  description = "Set to `true` for WAF to allow requests by default. Set to `false` for WAF to block requests by default."
  default     = true
}

variable "whitelist_ips" {
  type    = list(any)
  default = []
}


variable filter_path_patterns {
  type = list(any)
  default = ["/wp-admin", "/wp-login.php", "/wp-json/wp/v2/users"]
}



