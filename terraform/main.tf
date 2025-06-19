# Terraform Configuration
terraform {
  required_version = "1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}

provider "aws" {
  region = var.region
}

# ACM certificates for cloudfront must be in us-east-1; provider alias
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
