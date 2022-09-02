# variable "service_name" {}

variable "env" {
  default = ""
}

variable "project_name" {
  default = ""
}

variable "bucket_name" {
  default = ""
}

variable "service_name" {
  default = ""
}


variable "bucket_name_arn" {
  default = ""
}

variable "bucket_regional_domain_name" {
  default = ""
}


variable "s3_bucket_logs_name" {
  default = "cf-logs"
}


variable "cf_price_class" {
  default = "PriceClass_200"
}


variable "cf_alias_domain" {
  type    = list(string)
  default = []
}

variable "cf_certificate_arn" {
  type    = string
  default = null
}

variable "cf_extra_header_key" {
  default = "ALLOW-KEY"
}

variable "cf_extra_header_value" {
  default = "123456"
}

variable "dynamic_origin" {
  default = ""
}

variable "web_acl_id" {
  default = ""
}

variable "minimum_protocol_version" {
  default = "TLSv1"
}

variable "ssl_support_method" {
  # default = "sni-only"
  type = string
  # default = null
  default = "sni-only"
}

variable "website_cache_default_ttl" {
  type    = number
  default = 86400
}


variable "website_cache_min_ttl" {
  type    = number
  default = 0
}

variable "website_cache_max_ttl" {
  type    = number
  default = 31536000
}

variable "wp_content_path_pattern" {
  type    = string
  default = "wp-content/uploads/*"
}

variable "wp_login_path_pattern" {
  type    = string
  default = "wp-login.php"
}

variable "wp_admin_path_pattern" {
  type    = string
  default = "wp-admin/*"
}

variable "tags" {
  type = any
  default = {
    "Manage_by" = "Terraform"
  }
}


variable "enable_maintainance_mode" {
  type    = string
  default = false
}

variable "maintainance_page" {
  type    = string
  default = "/error-pages/maintainance-mode.html"
}

variable "page_5xx" {
  type    = string
  default = "/error-pages/500-page.html"
}

variable "page_4xx" {
  type    = string
  default = "/error-pages/403-page.html"
}



variable "custom_error_responses" {
  default = {
      403 = {
        error_caching_min_ttl = 10
        error_code            = 403
        response_code         = 403
        response_page_path    = null  
      }
      500 = {
        error_caching_min_ttl = 10
        error_code            = 500
        response_code         = 500
        response_page_path    = null     
      }
      502 = {
        error_caching_min_ttl = 10
        error_code            = 502
        response_code         = 502
        response_page_path    = null         
      }
      504 = {
        error_caching_min_ttl = 10
        error_code            = 504
        response_code         = 504
        response_page_path    = null            
      }
      503 = {
        error_caching_min_ttl = 10
        error_code            = 503
        response_code         = 503
        response_page_path    = null           
      }
    }
}
