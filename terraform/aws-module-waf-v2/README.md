# README

|Variable|Description|
|-|-|
|service_name|service name|
|enable_rate_limit_access|enable rate limit access||
|limit_requests_per_5_min||
|resource_associate_web_acl_arn|resource api gateway or alb to associate|
|enable_filter_access_path||
|path_fillter||
|aws_wafv2_rule_restrict_country_arn||
|enable_restrict_country_access||

```

module "wafv2" {
    source                          = "https://devops-vl.vietlinkads.com/private/aws-module-waf-v2/v0.0.1.zip?token=placer"
    service_name                    = "api"
    enable_rate_limit_access        = true
    resource_associate_web_acl_arn  = data.terraform_remote_state.api.outputs.api_alb_arn
    project_name                    = var.project_name
    env                             = var.env
    limit_requests_per_5_min        = 3000
}
```