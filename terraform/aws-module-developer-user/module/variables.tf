variable "user_name" {
  default = "developer"
}

variable "policy_arn" {
  default = []
}


variable "ip_retrict" {
  default = [ 
    "13.114.248.99/32",
    "14.161.26.162/32",
    "52.76.186.173/32"
  ]
}
