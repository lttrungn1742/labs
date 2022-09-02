variable "project_name" { default = "" }
variable "env" { default = "" }

variable "aws_managed_rule_groups" {
  default = [
    {
      name    = "AWSManagedRulesCommonRuleSet"
      exclude = []
    },
    {
      name    = "AWSManagedRulesKnownBadInputsRuleSet"
      exclude = []
    },
    {
      name    = "AWSManagedRulesAmazonIpReputationList"
      exclude = []
    }
  ]
}



variable "service_name" {}

variable "aws_wafv2_rule_restrict_country_arn" {
  default = null
}

variable "enable_restrict_country_access" {
  default = false
}

variable "enable_filter_access_path" {
  default = false
}

variable "path_fillter" {
  default = null
}

variable "enable_rate_limit_access" {
  default = false
}


variable "limit_requests_per_5_min" {
  default = 500
}

variable "resource_associate_web_acl_arns" {
  type = list
}

variable "tags" {
  default = null
}