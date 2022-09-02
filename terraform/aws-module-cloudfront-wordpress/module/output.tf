output "cloudfront_url" {
  value = aws_cloudfront_distribution.cf_resource.domain_name
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.cf_resource.arn
}

output "cloudfront_access_identity_path" {
  value = aws_cloudfront_origin_access_identity.static_s3_bucket_origin_access_identity.cloudfront_access_identity_path
}

output "static_s3_bucket_policy_data" {
  value = data.aws_iam_policy_document.static_s3_bucket_policy_data.json
}


output "last_modified_time" {
  value = aws_cloudfront_distribution.cf_resource.last_modified_time
}


output "cloudfront_id" {
  value = aws_cloudfront_distribution.cf_resource.id
}
