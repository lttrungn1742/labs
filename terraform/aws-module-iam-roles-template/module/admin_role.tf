resource "aws_iam_role" "admin" {
  name                = var.admin_role_name
  assume_role_policy  = data.template_file.assume_role.rendered
  tags                = var.tags
}


data "template_file" "assume_role" {
    template    =   "${file("${path.module}/iam-policies/role.json")}"
    vars = {
      "aws_trusted_bastion_accts" = "${jsonencode(var.aws_trusted_bastion_accts)}"
    }
}

resource "aws_iam_role_policy_attachment" "admin" {
  role                = aws_iam_role.admin.name
  policy_arn          = var.admin_policy_arn
}