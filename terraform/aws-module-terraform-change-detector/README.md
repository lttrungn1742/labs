# README #

This README would normally document whatever steps are necessary to get your application up and running.


|Variable|Description|
|-|-|
|count|condition to create the terraform change detector|
|tags|||
|name_prefix|||
|project_name|name of project|
|env|name of environment|
|aws_region|name of region|
|retention_in_days| the expiration day of the log group|
|python_runtime|the version of python|
|lambda_environments|name of channel recieve the notification|
|||


```
module "detec" {
  count = var.enable_terraform_change_detector ? 1 : 0
  source         = "https://devops-vl.vietlinkads.com/private/aws-module-terraform-change-detector/v0.0.2.zip?token=thisisaveryseriouslyencryptedtoken"
  tags           = local.common_tags
  name_prefix    = local.name_prefix
  project_name   = var.project_name
  env            = var.env
  aws_region     = var.aws_region
  retention_in_days = var.retention_in_days
  python_runtime = var.python_runtime
  lambda_environments = merge(var.lambda_environments,
    {
      "ENV"     = var.env
      "PROJECT" = var.project_name
    }
  )

}
```