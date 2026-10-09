terraform {
  backend "s3" {
    bucket = "terraform-bucket-backend-new"
    key    = "networking/VPC-Peering/terraform.tfstate"
    region = "ap-south-1"
  }
}
