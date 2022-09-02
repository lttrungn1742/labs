

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${local.name_prefix}-${var.service_name}-cloudfront-site-access-identity"
}

resource "aws_cloudfront_distribution" "this" {
  comment = "${local.name_prefix}-${var.service_name} CF Distribution"
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = "s3-cloudfront-${local.name_prefix}-${var.service_name}"
    origin_path = "/public"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.enable_alias ? [var.service_alias] : []
  
  logging_config {
    include_cookies = false
    bucket = aws_s3_bucket.cloudfront_logs.bucket_regional_domain_name
    prefix = "cf-logs-${local.name_prefix}-${var.service_name}" 
  }
  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = "s3-cloudfront-${local.name_prefix}-${var.service_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    dynamic "function_association" {
      for_each = var.cf_function != null ? [ var.cf_function ] : []

      content {
        event_type   = "viewer-request" 
        function_arn = function_association.value
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.enable_alias ? false : true  
    acm_certificate_arn = var.enable_alias ? (var.enable_acm_cer ? aws_acm_certificate.this.0.arn : var.acm_arn ) : null
    ssl_support_method  = "sni-only"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 10
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_code            = 404
    response_code         = 200
    error_caching_min_ttl = 10
    response_page_path    = "/index.html"
  }

  wait_for_deployment = false
  depends_on          = [aws_s3_bucket.this, aws_s3_bucket.cloudfront_logs, aws_acm_certificate.this]
  tags                = local.common_tags

  web_acl_id = var.web_acl_id != "" ? var.web_acl_id : null
  


}


