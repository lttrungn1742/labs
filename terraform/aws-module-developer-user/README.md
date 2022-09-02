# Module for create use developer

- `user_name`: (required _no_), default `developer`

- `policy_arn`: (required _no_), default `[]`
example to use it:
```
variable "policy_arn" {
  default     = [
    "arn:aws:iam::127086217485:policy/user-sqs",
    "arn:aws:iam::127086217485:policy/T_S3_LIST_READ"
  ]
}
```

- `ip_retrict`: (required: _No_), type: `List`,   default = [ 
                                        "13.114.248.99/32",
                                        "14.161.26.162/32",
                                        "52.76.186.173/32"
                                      ]
