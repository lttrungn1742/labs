output "proper_arn" {
    value = aws_iam_role.proper.arn
}

output "developer_arn" {
    value = aws_iam_role.developer.arn
}

output "readonly_arn" {
    value = aws_iam_role.readonly.arn
}

output "admin_arn" {
    value = aws_iam_role.admin.arn
}

