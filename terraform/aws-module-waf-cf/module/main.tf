terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_caller_identity" "current" {}



resource "aws_wafv2_ip_set" "whitelist_ip" {
  name               = "${var.prefix}-whitelist-ips"
  description        = "The whitelist ip that is allowed to access the cloudfront"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.whitelist_ips

  tags = var.tags
}

resource "aws_wafv2_web_acl" "acl" {
  name        = "${var.prefix}-acl"
  description = "Web ACL for wordpress for ${var.prefix} via Terraform"
  scope       = "CLOUDFRONT"
  tags        = var.tags

  default_action {
    dynamic "allow" {
      for_each = var.allow_default_action ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.allow_default_action ? [] : [1]
      # Despite seemingly would want to add default custom_response defintions here, the docs state an empyt configuration block is required. ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#default-action
      content {}
    }
  }

  # Defautl action is block with the whitelist ip rule.
  dynamic "rule" {

    for_each = var.allow_default_action ? [] : [1]

    content {
      name     = "whitelist-ip"
      priority = 1

      action {
        allow {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.whitelist_ip.arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.waf_enable_cloudwatch_metric
        metric_name                = "${var.prefix}-whitelist-ip-rule"
        sampled_requests_enabled   = var.waf_enable_sample_request
      }
    }

  }

# Default action is allow with rate-limit.
  dynamic "rule" {

    for_each = var.allow_default_action ? [1] : []

    content {
      name     = "rate-requests"
      priority = 1
      action {
        block {}
        // count {}
        // for implement on production. We will change to block if no issues
      }
      statement {
        rate_based_statement {
          limit              = var.waf_rate_limit
          aggregate_key_type = "IP"
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = var.waf_enable_cloudwatch_metric
        metric_name                = "${var.prefix}-rate-limit-access-rule"
        sampled_requests_enabled   = var.waf_enable_sample_request
      }
    }

  }

  dynamic "rule" {
    for_each = var.allow_default_action ? [1] : []
    content{
        name     = "fillter-access-path"
        priority = 2
        action {
          block {}
        }

        statement {
          and_statement{
            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.whitelist_ip.arn
                  }
                }
              }
            }
                statement {
                  or_statement {
                      dynamic "statement" {
                        for_each = toset(var.filter_path_patterns)

                        content {
                          byte_match_statement {
                            field_to_match {
                              uri_path {}
                            }
                            positional_constraint = "STARTS_WITH"
                            search_string         = statement.value
                            text_transformation {
                              priority = 1
                              type     = "NONE"
                            }
                          }
                        }
                      }
                  }
                }
          }
        }
        visibility_config {
          cloudwatch_metrics_enabled = var.waf_enable_cloudwatch_metric
          metric_name                = "${var.prefix}-filter-access-path"
          sampled_requests_enabled   = var.waf_enable_sample_request
        }
    }
      
  }

  dynamic "rule" {
    for_each = var.external_rule_groups
    content {
      name     = "user-rule-group-${rule.value[0]}"
      priority = 3 + rule.key
      override_action {
        none {}
      }
      statement {
        rule_group_reference_statement {
          arn = rule.value[1]
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = var.waf_enable_cloudwatch_metric
        metric_name                = "${var.prefix}-user-rule-group-${rule.value[0]}"
        sampled_requests_enabled   = var.waf_enable_sample_request
      }
    }
  }

  dynamic "rule" {
    for_each = var.waf_aws_manage_rule_group
    content {
      name     = "aws-manage-rule-group-${rule.value.name}"
      priority = 4 + length(var.external_rule_groups) + rule.key
      override_action {
        none {}
        // count {}
        // for implement on production. We will change to block if no issues
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = "AWS"

          dynamic "excluded_rule" {
            for_each = rule.value.exclude
            content {
              name = excluded_rule.value
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = var.waf_enable_cloudwatch_metric
        metric_name                = "${var.prefix}-${rule.value.name}"
        sampled_requests_enabled   = var.waf_enable_sample_request
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.waf_enable_cloudwatch_metric
    metric_name                = "${var.prefix}-acl"
    sampled_requests_enabled   = var.waf_enable_sample_request
  }
}

