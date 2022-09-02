# Module for resource CloudFront and S3

## Variable
- service_name : name of service
<br> required: Yes
- project_name : name of project
<br> required: Yes
- env : environment to develop project
<br> required: Yes
- enable_alias : if true, create acm certificate. Default false
<br> required: No
- service_alias: domain
<br> required: Yes when enable_alias is true
- `src_cloudfront_function`: source code function of resource `aws_cloudfront_function`, require: No

## Example
```
# case 1 no alias
module "s3_cloudfront1" {
    source = "../../../modules/s3_cloudfront"
    service_name = "games"
}

```
- it will create resource, have no alias, no acm_cerfi

```
# case 2 alias with user input acm
module "s3_cloudfront2" {
    source = "../../../modules/s3_cloudfront"
    project_name    = var.unlimited_project_name
    service_name    = "top"
    region          = var.region
    env             = var.application_env
    
    service_alias = "example.com"
    enable_alias = true
    acm_arn = "arn:aws:acm:region:account:certificate/certificate_ID_1"
}
```
- it will create resource, have alias and no acm_cerfi
```
# case 3 alias and create acm auto
module "s3_cloudfront3" {
    source = "../../../modules/s3_cloudfront"
    service_name = "games"
    service_alias = "example.com"
    enable_alias = true
    enable_acm_cer = true
}
```
- it will create resource, have alias and acm_cerfi