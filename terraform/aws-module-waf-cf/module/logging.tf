# resource "aws_wafv2_web_acl_association" "alb" {
#   resource_arn = var.association_resource_arn
#   web_acl_arn  = aws_wafv2_web_acl.acl.arn
# }

# resource "aws_s3_bucket" "waf_logs" {
#     bucket = "${var.project_name}-${var.env}-front-waf-logs"
#     acl = "private"
#     tags = local.tags

#     lifecycle_rule {
#         id = "logs"
#         enabled = true
#         dynamic transition {
#             for_each = var.s3_lifecycle
#             content {
#                 days = transition.value.days
#                 storage_class = transition.value.storage_class
#             }
#         }
#         expiration {
#             days = var.s3_expiration
#         }
#     }
# }

# resource "aws_iam_role" "kinesis_waf_logs" {
#     name = "${var.project_name}-${var.env}-kinesis-front-waf-logs"
#     tags = local.tags
#     assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "firehose.amazonaws.com"
#       },
#       "Effect": "Allow"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "kinesis_waf_logs" {
#   name = "kinesis-front-waf-logs"
#   role = aws_iam_role.kinesis_waf_logs.id
#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "s3Access",
#             "Effect": "Allow",
#             "Action": [
#                 "s3:AbortMultipartUpload",
#                 "s3:GetBucketLocation",
#                 "s3:GetObject",
#                 "s3:ListBucket",
#                 "s3:ListBucketMultipartUploads",
#                 "s3:PutObject"
#             ],
#             "Resource": [
#                 "${aws_s3_bucket.waf_logs.arn}",
#                 "${aws_s3_bucket.waf_logs.arn}/*"
#             ]
#         },
#         {
#             "Sid": "logsAccess",
#             "Effect": "Allow",
#             "Action": [
#                 "logs:PutLogEvents",
#                 "logs:CreateLogStream",
#                 "logs:DescribeLogStreams"
#             ],
#             "Resource": [
#                 "${aws_cloudwatch_log_group.front_kinesis.arn}/*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "kms:GenerateDataKey",
#                 "kms:Decrypt"
#             ],
#             "Resource": [
#                 "arn:aws:kms:ap-northeast-1:${data.aws_caller_identity.current.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
#             ],
#             "Condition": {
#                 "StringEquals": {
#                     "kms:ViaService": "s3.ap-northeast-1.amazonaws.com"
#                 },
#                 "StringLike": {
#                     "kms:EncryptionContext:aws:s3:arn": [
#                         "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"
#                     ]
#                 }
#             }
#         },
#         {
#             "Sid": "",
#             "Effect": "Allow",
#             "Action": [
#                 "kinesis:DescribeStream",
#                 "kinesis:GetShardIterator",
#                 "kinesis:GetRecords",
#                 "kinesis:ListShards"
#             ],
#             "Resource": "arn:aws:kinesis:ap-northeast-1:${data.aws_caller_identity.current.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "kms:Decrypt"
#             ],
#             "Resource": [
#                 "arn:aws:kms:ap-northeast-1:842462751531:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
#             ],
#             "Condition": {
#                 "StringEquals": {
#                     "kms:ViaService": "kinesis.ap-northeast-1.amazonaws.com"
#                 },
#                 "StringLike": {
#                     "kms:EncryptionContext:aws:kinesis:arn": "arn:aws:kinesis:ap-northeast-1:${data.aws_caller_identity.current.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
#                 }
#             }
#         }
#     ]
# }
# EOF
# }

# resource "aws_cloudwatch_log_group" "front_kinesis" {
#   name = "/aws/kinesisfirehose/${var.project_name}-${var.env}-front-waf-logs"
#   retention_in_days = var.cloudwatch_log_retention
#   tags = local.tags
# }

# resource "aws_kinesis_firehose_delivery_stream" "waf_logs" {
#     name = "aws-waf-logs-${var.project_name}-${var.env}-front-waf-logs"
#     destination = "extended_s3"
#     extended_s3_configuration {
#         role_arn = aws_iam_role.kinesis_waf_logs.arn
#         bucket_arn = aws_s3_bucket.waf_logs.arn
#         buffer_size = var.kinesis_buffer_size
#         buffer_interval = var.kinesis_buffer_interval
#         compression_format = "UNCOMPRESSED"
#         s3_backup_mode     = "Disabled"

#         cloudwatch_logging_options {
#             enabled         = true
#             log_group_name  = aws_cloudwatch_log_group.front_kinesis.name
#             log_stream_name = "frontKinesisLogs"
#         }

#         processing_configuration {
#             enabled = false
#         }
#     }

#     server_side_encryption {
#         enabled = false
#     }
# }

# resource "aws_wafv2_web_acl_logging_configuration" "waf_logs" {
#     log_destination_configs = [
#         aws_kinesis_firehose_delivery_stream.waf_logs.arn
#     ]
#     resource_arn = aws_wafv2_web_acl.acl.arn
# }
