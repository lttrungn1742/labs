resource "aws_iam_role" "developer" {
  name                = var.developer_role_name
  assume_role_policy  = data.template_file.assume_role.rendered
  tags                = var.tags
}


data "template_file" "developer_policy" {
    template    =   "${file("${path.module}/iam-policies/developer.json")}"
    vars = {
      "deny_regions" = "${jsonencode(var.deny_regions)}"
    }
}

resource "aws_iam_policy" "developer" {
  name                = local.developer_policy_name
  description         = "Policy for Developer"
  policy              =  var.developer_json_policy == null ? data.template_file.developer_policy.rendered : var.developer_json_policy
  tags                = var.tags
}



resource "aws_iam_role_policy_attachment" "developer" {
  role                = aws_iam_role.developer.name
  policy_arn          = aws_iam_policy.developer.arn
}