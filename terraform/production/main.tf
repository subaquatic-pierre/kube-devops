terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5.2"
    }
  }

  required_version = ">= 1.15.7"
}


provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Environment = var.env
      Terraform   = true
    }
  }
}

terraform {
  backend "s3" {
    bucket = "kube-devops-032796414879-us-east-2-an"
    key    = "/${var.env}/terraform.tfstate"
    region = "us-east-2"
  }
}

