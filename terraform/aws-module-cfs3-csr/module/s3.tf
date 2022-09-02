resource "aws_s3_bucket" "this" {
  bucket = "${local.name_prefix}-${var.service_name}-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }

  tags = local.common_tags
}
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = {
          "AWS" : aws_cloudfront_origin_access_identity.this.iam_arn,
        }
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.this.arn}",
          "${aws_s3_bucket.this.arn}/public",
          "${aws_s3_bucket.this.arn}/public/*",
        ]
      },
    ]
  })
}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "${local.name_prefix}-${var.service_name}-cloudfront-logs"
  acl    = "log-delivery-write"
  lifecycle_rule {
    id      = "${local.name_prefix}-${var.service_name}-cloudfront-logs-lifecycle"
    enabled = true
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 365
    }
  }
  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


