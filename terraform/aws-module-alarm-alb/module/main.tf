resource "aws_cloudwatch_metric_alarm" "un_healthy" {
  for_each      = var.create_un_healthy_alarm ? var.target_group_arns : {}
  alarm_name    = "${var.name_prefix}-${var.alb_name}-unhealthy-${each.key}"
  alarm_actions = var.alarm_actions

  alarm_description   = "${var.name_prefix}-${var.alb_name}-unhealthy-${each.key}"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "TargetGroup"     = each.value,
    "LoadBalancer"    = var.alb_arn
  }
  evaluation_periods = 1
  metric_name        = "UnHealthyHostCount"
  namespace          = "AWS/ApplicationELB"
  period             = 60
  statistic          = "Maximum"

  threshold          = 0
  treat_missing_data = "notBreaching"

  tags = var.common_tags
}


resource "aws_cloudwatch_metric_alarm" "healthy" {
  for_each          = var.create_healthy_alarm ? var.target_group_arns : {}
  alarm_name        = "${var.name_prefix}-${var.alb_name}-healthy-${each.key}"
  alarm_actions     = var.alarm_actions

  alarm_description   = "${var.name_prefix}-${var.alb_name}-healthy-${each.key}"
  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "TargetGroup"  = each.value,
    "LoadBalancer" = var.alb_arn
  }
  evaluation_periods = 1
  metric_name        = "HealthyHostCount"
  namespace          = "AWS/ApplicationELB"
  period             = 60
  statistic          = "Maximum"

  threshold          = var.healthy_threshold
  treat_missing_data = "missing"

  tags = var.common_tags
}


resource "aws_cloudwatch_metric_alarm" "http_5xx" {
  count      = var.create_http_5xx_alarm ? 1 : 0
  alarm_name = "${var.name_prefix}-${var.alb_name}-http-5xx"
  alarm_actions = var.alarm_actions

  alarm_description   = "${var.name_prefix}-${var.alb_name}-http-5xx"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "LoadBalancer" = var.alb_arn
  }
  evaluation_periods = 1
  metric_name        = "HTTPCode_Target_5XX_Count"
  namespace          = "AWS/ApplicationELB"
  period             = 60
  statistic          = "Sum"

  threshold          = var.threshold_http_5xx
  treat_missing_data = "notBreaching"

  tags = var.common_tags
}


resource "aws_cloudwatch_metric_alarm" "lb_5xx" {
  count      = var.create_lb_5xx_alarm ? 1 : 0
  alarm_name = "${var.name_prefix}-${var.alb_name}-lb-5xx"
  alarm_actions = var.alarm_actions

  alarm_description   = "${var.name_prefix}-${var.alb_name}-lb-5xx"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    "LoadBalancer" = var.alb_arn
  }
  evaluation_periods = 1
  metric_name        = "HTTPCode_ELB_500_Count"
  namespace          = "AWS/ApplicationELB"
  period             = 60
  statistic          = "Sum"

  threshold          = var.threshold_elb_5xx
  treat_missing_data = "notBreaching"

  tags = var.common_tags
}

resource "aws_cloudwatch_metric_alarm" "target_connection_error_count" {

  for_each      = var.create_target_connection_error_count_alarm ? var.target_group_arns : {}
  alarm_name = "${var.name_prefix}-${var.alb_name}-target-connection-error-count-${each.key}"
  alarm_actions = var.alarm_actions

  alarm_description   = "Warning: TargetConnectionErrorCount is more than ${var.threshold_target_connection_error_count}. Please monitor and pay attention to this"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 5
  dimensions = {
    "TargetGroup"  = each.value,
    "LoadBalancer" = var.alb_arn
  }
  evaluation_periods = 5
  metric_name        = "TargetConnectionErrorCount"
  namespace          = "AWS/ApplicationELB"
  period             = 60
  statistic          = "Sum"

  threshold          = var.threshold_target_connection_error_count
  treat_missing_data = "notBreaching"

  tags = var.common_tags
}


resource "aws_cloudwatch_metric_alarm" "target_response_time" {

  count      = var.create_target_response_time_alarm ? 1 : 0
  alarm_name = "${var.name_prefix}-${var.alb_name}-target-response-time"
  alarm_actions = var.alarm_actions

  alarm_description   = "${var.name_prefix}-${var.alb_name}-target-response-time"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 5
  dimensions = {
    "LoadBalancer" = var.alb_arn
  }
  evaluation_periods = 5
  metric_name        = "TargetResponseTime"
  namespace          = "AWS/ApplicationELB"
  period             = 60
  statistic          = "Average"

  threshold          = var.threshold_target_response_time
  treat_missing_data = "notBreaching"

  tags = var.common_tags
}


resource "aws_cloudwatch_metric_alarm" "request_count" {
  for_each            = var.create_request_count_alarm ? var.target_group_arns : {}
  alarm_name          = "${var.name_prefix}-${var.alb_name}-request-count-${each.key}"
  alarm_actions       = var.alarm_actions

  alarm_description   = "Warning: Request count is more than ${var.threshold_request_count}. Please monitor and scale resources as you go"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = 5
  dimensions = {
    "TargetGroup"  = each.value,
    "LoadBalancer" = var.alb_arn
  }
  evaluation_periods = 5
  metric_name        = "RequestCountPerTarget"
  namespace          = "AWS/ApplicationELB"
  period             = 60
  statistic          = "Sum"

  threshold          = var.threshold_request_count
  treat_missing_data = "notBreaching"

  tags = var.common_tags
}
