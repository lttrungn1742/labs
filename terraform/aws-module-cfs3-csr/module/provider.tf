provider "aws" {
  alias  = "main"
  region = var.region
}

provider "aws" {
  alias  = "acmglobal"
  region = "us-east-1"
}
