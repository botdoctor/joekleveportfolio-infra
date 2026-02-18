terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# CloudFront certs MUST be in us-east-1 - this is a second provider alias
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
