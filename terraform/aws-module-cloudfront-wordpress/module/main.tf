resource "aws_cloudfront_origin_access_identity" "static_s3_bucket_origin_access_identity" {
  comment = "Origin Access Identity for ${var.service_name} bucket ${var.project_name}-${var.env}-${var.service_name}"
}

data "aws_iam_policy_document" "static_s3_bucket_policy_data" {
  statement {
    sid     = "GetObjectandAndListBucket"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "${var.bucket_name_arn}/*",
      "${var.bucket_name_arn}"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "${aws_cloudfront_origin_access_identity.static_s3_bucket_origin_access_identity.iam_arn}"
      ]
    }
  }
}


resource "aws_s3_bucket_policy" "static_s3_bucket_policy_attachment" {
  bucket = var.bucket_name
  policy = data.aws_iam_policy_document.static_s3_bucket_policy_data.json
}


# Cloudfront
resource "aws_cloudfront_distribution" "cf_resource" {
  origin {
    domain_name = var.dynamic_origin
    origin_id   = "alb-dynamic-wordpress-origin"

    custom_header {
      name  = var.cf_extra_header_key
      value = var.cf_extra_header_value
    }

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  web_acl_id = var.web_acl_id != "" ? var.web_acl_id : null

  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.bucket_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_s3_bucket_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront for ${var.project_name} ${var.service_name} ${var.env} ${var.service_name}"
  default_root_object = ""

  logging_config {
    include_cookies = false
    bucket          = "${var.s3_bucket_logs_name}.s3.amazonaws.com"
    prefix          = var.service_name
  }

  aliases = var.cf_alias_domain



  dynamic "viewer_certificate" {
    for_each = length(var.cf_alias_domain) == 0 ? [1] : []
    content {
      cloudfront_default_certificate = true
    }
  }


  dynamic "viewer_certificate" {
    for_each = length(var.cf_alias_domain) == 0 ? [] : [1]
    content {
      acm_certificate_arn            = var.cf_certificate_arn
      cloudfront_default_certificate = false
      minimum_protocol_version = var.minimum_protocol_version
      ssl_support_method = var.ssl_support_method
    }
  }




  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = var.website_cache_default_ttl
    max_ttl                = var.website_cache_max_ttl
    min_ttl                = var.website_cache_min_ttl
    smooth_streaming       = false
    target_origin_id       = "alb-dynamic-wordpress-origin"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "CloudFront-Forwarded-Proto",
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-Tablet-Viewer",
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "comment_*",
          "wordpress_*",
          "wp-settings-*",
        ]
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = var.website_cache_default_ttl
    max_ttl                = var.website_cache_max_ttl
    min_ttl                = var.website_cache_min_ttl
    path_pattern           = var.wp_admin_path_pattern
    smooth_streaming       = false
    target_origin_id       = "alb-dynamic-wordpress-origin"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = ["*"]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]

    compress               = true
    default_ttl            = var.website_cache_default_ttl
    max_ttl                = var.website_cache_max_ttl
    min_ttl                = var.website_cache_min_ttl
    path_pattern           = var.wp_login_path_pattern
    smooth_streaming       = false
    target_origin_id       = "alb-dynamic-wordpress-origin"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = ["*"]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = var.website_cache_default_ttl
    max_ttl                = var.website_cache_max_ttl
    min_ttl                = var.website_cache_min_ttl
    path_pattern           = var.wp_content_path_pattern
    smooth_streaming       = false
    target_origin_id       = var.bucket_name
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = []
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = var.website_cache_default_ttl
    max_ttl                = var.website_cache_max_ttl
    min_ttl                = var.website_cache_min_ttl
    path_pattern           = "error-pages/*"
    smooth_streaming       = false
    target_origin_id       = var.bucket_name
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      headers                 = []
      query_string            = false
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }

  price_class = var.cf_price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"

    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses

    content {
      error_caching_min_ttl = custom_error_response.value["error_caching_min_ttl"]
      error_code            = custom_error_response.value["error_code"]
      response_code         = custom_error_response.value["response_code"]
      response_page_path    = (custom_error_response.value["response_page_path"] != null)  ? custom_error_response.value["response_page_path"] : ( custom_error_response.value["error_code"] != 403 ? var.page_5xx : (var.enable_maintainance_mode ? var.maintainance_page : var.page_4xx))
    }
  }
  tags = var.tags


  lifecycle {
    ignore_changes = [
      last_modified_time,
      status,
      etag

    ]
  }
}
