output aws_lambda_function {
    value = aws_lambda_function.terraform_changes_detector
}

output lambda_aws_iam_role {
    value = aws_iam_role.terraform_changes_detector
}