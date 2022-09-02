
resource "aws_acm_certificate" "this" {
  provider          = aws.acmglobal 
  domain_name       =  var.service_alias 
  count             = var.enable_alias ? ( var.enable_acm_cer ? 1 : 0) : 0
  validation_method = "DNS" 
  tags              =  local.common_tags
  
  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_route53_record" "cfs3_csr_cert" {
  count   = var.zone_id != null && var.enable_acm_cer == false ? 1 : 0
  zone_id = var.zone_id
  name    = aws_acm_certificate.this.0.domain_validation_options.*.resource_record_name[0]
  type    =  aws_acm_certificate.this.0.domain_validation_options.*.resource_record_type[0]
  ttl     = "60"
  records = [aws_acm_certificate.this.0.domain_validation_options.*.resource_record_value[0]]
}

resource "aws_route53_record" "cfs3_csr_a" {
  count   = var.zone_id != null  && var.enable_acm_cer == false ? 1 : 0
  zone_id = var.zone_id
  name    = var.service_alias
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}