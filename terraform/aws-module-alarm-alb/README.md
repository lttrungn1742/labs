* Check here  - https://redmine.vietlinkads.com/projects/devops/wiki/How_to_create_a_new_terraform_module

```
module "alb_alarm" {
  # source           = "../../../modules/alarm-alb"
  source           = "https://devops-vl.vietlinkads.com/private/aws-module-alarm-alb/v0.0.12.zip?token=thisisaveryseriouslyencryptedtoken"
  name_prefix      = local.name_prefix
  alb_name         = "api"
  alb_arn          = aws_lb.this.arn_suffix
  target_group_arns = {
    target1 = aws_lb_target_group.tg_1.arn_suffix
    target2 = aws_lb_target_group.tg_2.arn_suffix
  }
  
  alarm_actions = [
    data.terraform_remote_state.common.outputs.chatbot.awschatbot_sns_topic_arn
  ]
  count                     = var.create_alb_alarm ? 1 : 0
  common_tags = local.common_tags
}
```