output "aws_s3_bucket_top" {
  value = aws_s3_bucket.this.bucket
}

output "aws_cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}