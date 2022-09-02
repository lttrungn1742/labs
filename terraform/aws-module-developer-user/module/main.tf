resource "aws_iam_user" "developer" {
  name      = var.user_name
  tags      = {
    manage  = "terraform"
  }
}

resource "aws_iam_user_policy" "deny_non_whitelist" {
  name    = "Deny-Non-Whitelist"
  user    = aws_iam_user.developer.name

  policy  = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Deny",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "${var.ip_retrict}"
                },
                "Bool": {"aws:ViaAWSService": "false"}
            }
        }
    ]
})
}


resource "aws_iam_user_policy_attachment" "policy_attach" {
  user        = aws_iam_user.developer.name
  for_each    = toset( var.policy_arn )
  policy_arn  = each.value
}