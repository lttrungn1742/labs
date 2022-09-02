# Setting for monitor for ALB
module "alb_alarm" {
  source           = "../../../modules/alarm-alb"
  name_prefix      = local.name_prefix
  alb_name         = "alb"
  alb_arn          = aws_lb.alb.arn_suffix
  target_group_arn = aws_lb_target_group.wordpress_target_group.arn_suffix
  alarm_actions = [
    var.alert_resource_topic_arn
  ]
  common_tags = local.common_tags
  create_un_healthy_alarm=true
  create_healthy_alarm=true
  healthy_threshold=2
  create_http_5xx_alarm=true
  create_lb_5xx_alarm=true
  create_target_connection_error_count_alarm=true
  create_target_response_time_alarm=true
  create_request_count_alarm=true
}