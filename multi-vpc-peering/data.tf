# Data Sources for 3 VPC Peering Demo

# Data source to get available AZs in First region
data "aws_availability_zones" "first" {
  provider = aws.first
  state    = "available"
}

# Data source to get available AZs in Second region
data "aws_availability_zones" "second" {
  provider = aws.second
  state    = "available"
}

# Data source to get available AZs in Third region
data "aws_availability_zones" "third" {
  provider = aws.third
  state    = "available"
}


# Data source for First region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "first_ami" {
  provider    = aws.first
  most_recent = true

  # We restricted AMI discovery using the official Canonical
  # publisher account ID to ensure trusted image sourcing.
  owners = ["099720109477"] # Canonical (Ubuntu)

  # Common Official Owner IDs
  # Ubuntu (Canonical)       099720109477
  # Amazon Linux             137112412989
  # Red Hat                  309956199498

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


# Data source for Second region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "second_ami" {
  provider    = aws.second
  most_recent = true

  owners = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


# Data source for Third region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "third_ami" {
  provider    = aws.third
  most_recent = true

  owners = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}