# Variables for VPC Peering Demo

variable "first_region" {
  description = "First AWS region for the first VPC"
  type        = string
  default     = "us-east-1"
}

variable "second_region" {
  description = "Second AWS region for the second VPC"
  type        = string
  default     = "ap-south-1"
}

variable "third_region" {
  description = "Third AWS region for the third VPC"
  type        = string
  default     = "ca-central-1"
}

variable "first_vpc_cidr" {
  description = "CIDR block for the first VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "second_vpc_cidr" {
  description = "CIDR block for the second VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "third_vpc_cidr" {
  description = "CIDR block for the third VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "first_subnet_cidr" {
  description = "CIDR block for the first subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "second_subnet_cidr" {
  description = "CIDR block for the second subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "third_subnet_cidr" {
  description = "CIDR block for the third subnet"
  type        = string
  default     = "10.2.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "first_key_name" {
  description = "Name of the SSH key pair for First VPC instance (us-east-1)"
  type        = string
  default     = ""
}

variable "second_key_name" {
  description = "Name of the SSH key pair for Second VPC instance (ap-south-1)"
  type        = string
  default     = ""
}

variable "third_key_name" {
  description = "Name of the SSH key pair for Third VPC instance (ca-central-1)"
  type        = string
  default     = ""
}