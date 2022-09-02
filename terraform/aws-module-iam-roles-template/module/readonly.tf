resource "aws_iam_role" "readonly" {
  name                = var.readonly_role_name
  assume_role_policy  = data.template_file.assume_role.rendered
  tags                = var.tags
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role            = aws_iam_role.readonly.name
  policy_arn      = var.readonly_policy_arn
}