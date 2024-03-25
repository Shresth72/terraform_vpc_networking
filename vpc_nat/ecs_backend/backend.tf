terraform {
  required_version = "~> 1.3"

  backend "s3" {
    bucket         = "myproject-tf-state-bucket"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-west-2"
    profile        = "default"
    dynamodb_table = "myproject-tf-state-lock-table"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
