terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


# Provider for the first region (us-east-1)
provider "aws" {
  region = var.first_region
  alias  = "first"
}

# Provider for the second region (ap-south-1)
provider "aws" {
  region = var.second_region
  alias  = "second"
}

# Provider for the third region (ca-central-1)
provider "aws" {
  region = var.third_region
  alias  = "third"
}