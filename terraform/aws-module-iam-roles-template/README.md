# Module iam role and policy

## Parameter of module
- `develop_policy`              : policy of develop
- `proper_policy`               : policy of proper
- `readonly_policy_arn`         : ARN of policy `ReadOnlyAccess`, default: `arn:aws:iam::aws:policy/ReadOnlyAccess` (required: No)
- `admin_policy_arn`            : ARN of policy `AdministratorAccess`, default: `arn:aws:iam::aws:policy/AdministratorAccess` (required: No)
- `aws_trusted_bastion_account` : ARN of aws account trust, default: `arn:aws:iam::123456789012:root`


## Would like to declare policy for develop and proper
- open `/iam_policy_template/iam/develop_role.json` file and modify it,
example:
```
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:Describe*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
}
```
-> proper as same as develop

## Example
```
module iam_role {
    source                        = "../../../../module/iam_role"
    developer_policy              = data.template_file.developer_role.rendered
    proper_policy                 = data.template_file.proper_role.rendered
    aws_trusted_bastion_account   = [
            "arn:aws:iam::123456789012:root",
            "arn:aws:iam::210987654321:root"
      ]
}

data "template_file" "developer_role" {
    template    =   "${file("./iam_policy_template/iam/develop_role.json")}"
}


data "template_file" "proper_role" {
    template    =   "${file("./iam_policy_template/iam/develop_role.json")}"
}


```

## Terraform plan
```
./terraform.sh -c iam -e dev -a plan
iam-dev
Terraform [plan] [iam]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.iam_role.aws_iam_policy.developer will be created
  + resource "aws_iam_policy" "developer" {
      + arn         = (known after apply)
      + description = "Policy for Developer"
      + id          = (known after apply)
      + name        = "DeveloperPolicy"
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "ec2:Describe*",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # module.iam_role.aws_iam_policy.proper will be created
  + resource "aws_iam_policy" "proper" {
      + arn         = (known after apply)
      + description = "Policy for Proper"
      + id          = (known after apply)
      + name        = "ProperPolicy"
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "ec2:Describe*",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # module.iam_role.aws_iam_role.admin will be created
  + resource "aws_iam_role" "admin" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Condition = {
                          + Bool  = {
                              + aws:MultiFactorAuthPresent = "true"
                            }
                        }
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS   = [
                              + "arn:aws:iam::142089030324:root",
                              + "arn:aws:iam::544729594538:root",
                            ]
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "AdminRole"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.iam_role.aws_iam_role.developer will be created
  + resource "aws_iam_role" "developer" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Condition = {
                          + Bool  = {
                              + aws:MultiFactorAuthPresent = "true"
                            }
                        }
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS = [
                              + "arn:aws:iam::142089030324:root",
                              + "arn:aws:iam::544729594538:root",
                            ]
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "DeveloperRole"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.iam_role.aws_iam_role.proper will be created
  + resource "aws_iam_role" "proper" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Condition = {
                          + Bool  = {
                              + aws:MultiFactorAuthPresent = "true"
                            }
                        }
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS   = [
                              + "arn:aws:iam::142089030324:root",
                              + "arn:aws:iam::544729594538:root",
                            ]
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "ProperRole"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.iam_role.aws_iam_role.readonly will be created
  + resource "aws_iam_role" "readonly" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Condition = {
                          + Bool  = {
                              + aws:MultiFactorAuthPresent = "true"
                            }
                        }
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS   = [
                              + "arn:aws:iam::123456789012:root",
                              + "arn:aws:iam::210987654321:root",
                            ]
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "ReadonlyRole"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.iam_role.aws_iam_role_policy_attachment.admin will be created
  + resource "aws_iam_role_policy_attachment" "admin" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
      + role       = "AdminRole"
    }

  # module.iam_role.aws_iam_role_policy_attachment.developer will be created
  + resource "aws_iam_role_policy_attachment" "developer" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "DeveloperRole"
    }

  # module.iam_role.aws_iam_role_policy_attachment.proper will be created
  + resource "aws_iam_role_policy_attachment" "proper" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "ProperRole"
    }

  # module.iam_role.aws_iam_role_policy_attachment.readonly will be created
  + resource "aws_iam_role_policy_attachment" "readonly" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      + role       = "ReadonlyRole"
    }

Plan: 10 to add, 0 to change, 0 to destroy.
```