resource "aws_iam_role" "proper" {
  name                = var.proper_role_name
  assume_role_policy  = data.template_file.assume_role.rendered
  tags                = var.tags
}


data "template_file" "proper_policy" {
    template    =   "${file("${path.module}/iam-policies/proper.json")}"
}

resource "aws_iam_policy" "proper" {
  name                = local.proper_policy_name
  description         = "Policy for Proper"
  policy              = var.proper_json_policy == null ? data.template_file.proper_policy.rendered : var.proper_json_policy
  tags                = var.tags
}


resource "aws_iam_role_policy_attachment" "proper" {
  role            = aws_iam_role.proper.name
  policy_arn      = aws_iam_policy.proper.arn
}