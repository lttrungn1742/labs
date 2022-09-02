variable "env" { default = "" }
variable "project_name" { default = "" }
variable "acl" { default = "private"}
variable "service_name" {  }

## Cloudfront
variable "service_alias" { default = "" }
variable "enable_alias" { default = "false" }
variable "enable_acm_cer" { default = "false" }
variable "cdn_ca_arn" { default = "" }
variable "price_class" { default = "PriceClass_100" }
variable "cloudfront_retain_on_delete" { default = true }
variable "cloudfront_wait_for_deployment" { default = false }
variable "cloudfront_create_origin_access_identity" { default = true }
variable "acm_arn" { default = null }
variable "web_acl_id" {  default = ""}
variable "region" { default = "" }

variable "zone_id" { default = null }

variable "cf_function" { default = null }
