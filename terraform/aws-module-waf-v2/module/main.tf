
resource "aws_wafv2_web_acl" "this" {
  name        = "${local.name_prefix}-web-acl-${var.service_name}"
  description = "WAF web acl for ${var.service_name}"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.enable_restrict_country_access ? [1] : []
    content {
      name     = "restrict-country-access"
      priority = 1

      override_action {
        none {}
      }

      statement {
        rule_group_reference_statement {
          arn = var.aws_wafv2_rule_restrict_country_arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${local.name_prefix}-${var.service_name}-rule-restrict-country-access"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_filter_access_path ? [1] : []
    content {
      name     = "filter-access-path"
      priority = 2

      action {
        block {}
      }

      statement {
        not_statement {
          statement {
            byte_match_statement {
              field_to_match {
                uri_path {}
              }
              positional_constraint = "STARTS_WITH"
              search_string         = var.path_fillter
              text_transformation {
                priority = 1
                type     = "NONE"
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${local.name_prefix}-${var.service_name}-filter-access-path"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = var.aws_managed_rule_groups
    content {
      name     = rule.value.name
      priority = 3 + rule.key
      override_action {
        none {}
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
        cloudwatch_metrics_enabled = true
        metric_name                = "${local.name_prefix}-${var.service_name}-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_rate_limit_access ? [1] : []
    content {
      name     = "rate-limit-access-rule"
      priority = 3 + length(var.aws_managed_rule_groups)

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = var.limit_requests_per_5_min
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${local.name_prefix}-${var.service_name}-rate-limit-access-rule"
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.name_prefix}-${var.service_name}-web-acl"
    sampled_requests_enabled   = true
  }

  tags = local.common_tags
}

resource "aws_wafv2_web_acl_association" "this" {
  for_each     =  toset( var.resource_associate_web_acl_arns )
  resource_arn = each.value
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
