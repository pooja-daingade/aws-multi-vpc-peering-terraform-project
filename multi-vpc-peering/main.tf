# This demo creates three VPCs in different regions and establishes peering between them

# First VPC in us-east-1
resource "aws_vpc" "first_vpc" {
  provider             = aws.first
  cidr_block           = var.first_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "First-VPC-${var.first_region}"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# Second VPC in ap-south-1
resource "aws_vpc" "second_vpc" {
  provider             = aws.second
  cidr_block           = var.second_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Second-VPC-${var.second_region}"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

 #Third VPC in ca-central-1
resource "aws_vpc" "third_vpc" {
  provider             = aws.third
  cidr_block           = var.third_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Third-VPC-${var.third_region}"
    Environment = "Demo"
    Purpose     = "VPC-Peering-Demo"
  }
}

# Subnet in First VPC
resource "aws_subnet" "first_subnet" {
  provider                = aws.first
  vpc_id                  = aws_vpc.first_vpc.id
  cidr_block              = var.first_subnet_cidr
  availability_zone       = data.aws_availability_zones.first.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "First-Subnet-${var.first_region}"
    Environment = "Demo"
  }
}

# Subnet in Second VPC
resource "aws_subnet" "second_subnet" {
  provider                = aws.second
  vpc_id                  = aws_vpc.second_vpc.id
  cidr_block              = var.second_subnet_cidr
  availability_zone       = data.aws_availability_zones.second.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Second-Subnet-${var.second_region}"
    Environment = "Demo"
  }
}

#Subnet in Third VPC
resource "aws_subnet" "third_subnet" {
  provider                = aws.third
  vpc_id                  = aws_vpc.third_vpc.id
  cidr_block              = var.third_subnet_cidr
  availability_zone       = data.aws_availability_zones.third.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Third-Subnet-${var.third_region}"
    Environment = "Demo"
  }
}

# Internet Gateway for First VPC
resource "aws_internet_gateway" "first_igw" {
  provider = aws.first
  vpc_id   = aws_vpc.first_vpc.id

  tags = {
    Name        = "First-IGW"
    Environment = "Demo"
  }
}

# Internet Gateway for Second VPC
resource "aws_internet_gateway" "second_igw" {
  provider = aws.second
  vpc_id   = aws_vpc.second_vpc.id

  tags = {
    Name        = "Second-IGW"
    Environment = "Demo"
  }
}

#Internet Gateway for Third VPC
resource "aws_internet_gateway" "third_igw" {
  provider = aws.third
  vpc_id   = aws_vpc.third_vpc.id

  tags = {
    Name        = "Third-IGW"
    Environment = "Demo"
  }
}

# Route table for First VPC
resource "aws_route_table" "first_rt" {
  provider = aws.first
  vpc_id   = aws_vpc.first_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.first_igw.id
  }

  tags = {
    Name        = "First-Route-Table"
    Environment = "Demo"
  }
}

# Route table for Second VPC
resource "aws_route_table" "second_rt" {
  provider = aws.second
  vpc_id   = aws_vpc.second_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.second_igw.id
  }

  tags = {
    Name        = "Second-Route-Table"
    Environment = "Demo"
  }
}

#Route table for Third VPC
resource "aws_route_table" "third_rt" {
  provider = aws.third
  vpc_id   = aws_vpc.third_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.third_igw.id
  }

  tags = {
    Name        = "Third-Route-Table"
    Environment = "Demo"
  }
}

# Associate route table with First subnet
resource "aws_route_table_association" "first_rta" {
  provider       = aws.first
  subnet_id      = aws_subnet.first_subnet.id
  route_table_id = aws_route_table.first_rt.id
}

# Associate route table with Second subnet
resource "aws_route_table_association" "second_rta" {
  provider       = aws.second
  subnet_id      = aws_subnet.second_subnet.id
  route_table_id = aws_route_table.second_rt.id
}

#Associate route table with Third subnet
resource "aws_route_table_association" "third_rta" {
  provider       = aws.third
  subnet_id      = aws_subnet.third_subnet.id
  route_table_id = aws_route_table.third_rt.id
}

# VPC Peering Connection (Requester side - First VPC)
resource "aws_vpc_peering_connection" "first_to_second" {
  provider    = aws.first
  vpc_id      = aws_vpc.first_vpc.id
  peer_vpc_id = aws_vpc.second_vpc.id
  peer_region = var.second_region
  auto_accept = false

  tags = {
    Name        = "First-to-Second-Peering"
    Environment = "Demo"
    Side        = "Requester"
  }
}

# VPC Peering Connection Accepter (Accepter side - Second VPC)
resource "aws_vpc_peering_connection_accepter" "second_accepter" {
  provider                  = aws.second
  vpc_peering_connection_id = aws_vpc_peering_connection.first_to_second.id
  auto_accept               = true

  tags = {
    Name        = "Second-Peering-Accepter"
    Environment = "Demo"
    Side        = "Accepter"
  }
}


# VPC Peering Connection (Requester side - Second VPC)
resource "aws_vpc_peering_connection" "second_to_third" {
  provider    = aws.second
  vpc_id      = aws_vpc.second_vpc.id
  peer_vpc_id = aws_vpc.third_vpc.id
  peer_region = var.third_region
  auto_accept = false

  tags = {
    Name        = "Second-to-Third-Peering"
    Environment = "Demo"
    Side        = "Requester"
  }
}

# VPC Peering Connection Accepter (Accepter side - Third VPC)
resource "aws_vpc_peering_connection_accepter" "third_accepter" {
  provider                  = aws.third
  vpc_peering_connection_id = aws_vpc_peering_connection.second_to_third.id
  auto_accept               = true

  tags = {
    Name        = "Third-Peering-Accepter"
    Environment = "Demo"
    Side        = "Accepter"
  }
}

# VPC Peering Connection (Requester side - Third VPC)
resource "aws_vpc_peering_connection" "third_to_first" {
  provider    = aws.third
  vpc_id      = aws_vpc.third_vpc.id
  peer_vpc_id = aws_vpc.first_vpc.id
  peer_region = var.first_region
  auto_accept = false

  tags = {
    Name        = "Third-to-First-Peering"
    Environment = "Demo"
    Side        = "Requester"
  }
}

# VPC Peering Connection Accepter (Accepter side - First VPC)
resource "aws_vpc_peering_connection_accepter" "first_accepter" {
  provider                  = aws.first
  vpc_peering_connection_id = aws_vpc_peering_connection.third_to_first.id
  auto_accept               = true

  tags = {
    Name        = "First-Peering-Accepter"
    Environment = "Demo"
    Side        = "Accepter"
  }
}


# Add route to Second VPC in First route table
resource "aws_route" "first_to_second" {
  provider                  = aws.first
  route_table_id            = aws_route_table.first_rt.id
  destination_cidr_block    = var.second_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.first_to_second.id

  depends_on = [aws_vpc_peering_connection_accepter.second_accepter]
}

# Add route to First VPC in Second route table
resource "aws_route" "second_to_first" {
  provider                  = aws.second
  route_table_id            = aws_route_table.second_rt.id
  destination_cidr_block    = var.first_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.first_to_second.id

  depends_on = [aws_vpc_peering_connection_accepter.second_accepter]
}



# Add route to Third VPC in Second route table
resource "aws_route" "second_to_third" {
  provider                  = aws.second
  route_table_id            = aws_route_table.second_rt.id
  destination_cidr_block    = var.third_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.second_to_third.id

  depends_on = [aws_vpc_peering_connection_accepter.third_accepter]
}

# Add route to Second VPC in Third route table
resource "aws_route" "third_to_second" {
  provider                  = aws.third
  route_table_id            = aws_route_table.third_rt.id
  destination_cidr_block    = var.second_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.second_to_third.id

  depends_on = [aws_vpc_peering_connection_accepter.third_accepter]
}


# Add route to First VPC in Third route table
resource "aws_route" "third_to_first" {
  provider                  = aws.third
  route_table_id            = aws_route_table.third_rt.id
  destination_cidr_block    = var.first_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.third_to_first.id

  depends_on = [
    aws_vpc_peering_connection_accepter.first_accepter
  ]
}


# Add route to Third VPC in First route table
resource "aws_route" "first_to_third" {
  provider                  = aws.first
  route_table_id            = aws_route_table.first_rt.id
  destination_cidr_block    = var.third_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.third_to_first.id

  depends_on = [
    aws_vpc_peering_connection_accepter.first_accepter
  ]
}


# Security Group for First VPC EC2 instance
resource "aws_security_group" "first_sg" {
  provider    = aws.first
  name        = "first-vpc-sg"
  description = "Security group for First VPC instance"
  vpc_id      = aws_vpc.first_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Second VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.second_vpc_cidr]
  }

  ingress {
    description = "All TCP traffic from Second VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.second_vpc_cidr]
  }

  ingress {
    description = "ICMP from Third VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.third_vpc_cidr]
  }

  ingress {
    description = "All TCP traffic from Third VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.third_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "First-VPC-SG"
    Environment = "Demo"
  }
}

# Security Group for Second VPC EC2 instance
resource "aws_security_group" "second_sg" {
  provider    = aws.second
  name        = "second-vpc-sg"
  description = "Security group for Second VPC instance"
  vpc_id      = aws_vpc.second_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from First VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.first_vpc_cidr]
  }

  ingress {
    description = "All TCP traffic from First VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.first_vpc_cidr]
  }

  ingress {
    description = "ICMP from Third VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.third_vpc_cidr]
  }

  ingress {
    description = "All TCP traffic from Third VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.third_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Second-VPC-SG"
    Environment = "Demo"
  }
}

# Security Group for Third VPC EC2 instance
resource "aws_security_group" "third_sg" {
  provider    = aws.third
  name        = "third-vpc-sg"
  description = "Security group for Third VPC instance"
  vpc_id      = aws_vpc.third_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from First VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.first_vpc_cidr]
  }

  ingress {
    description = "All TCP traffic from First VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.first_vpc_cidr]
  }

  ingress {
    description = "ICMP from Second VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.second_vpc_cidr]
  }

  ingress {
    description = "All TCP traffic from Second VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.second_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Third-VPC-SG"
    Environment = "Demo"
  }
}
# EC2 Instance in First VPC
resource "aws_instance" "first_instance" {
  provider               = aws.first
  ami                    = data.aws_ami.first_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.first_subnet.id
  vpc_security_group_ids = [aws_security_group.first_sg.id]
  key_name               = var.first_key_name

  user_data = local.first_user_data

  tags = {
    Name        = "First-VPC-Instance"
    Environment = "Demo"
    Region      = var.first_region
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.second_accepter,
    aws_vpc_peering_connection_accepter.third_accepter
  ]
}


# EC2 Instance in Second VPC
resource "aws_instance" "second_instance" {
  provider               = aws.second
  ami                    = data.aws_ami.second_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.second_subnet.id
  vpc_security_group_ids = [aws_security_group.second_sg.id]
  key_name               = var.second_key_name

  user_data = local.second_user_data

  tags = {
    Name        = "Second-VPC-Instance"
    Environment = "Demo"
    Region      = var.second_region
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.second_accepter,
    aws_vpc_peering_connection_accepter.third_accepter
  ]
}


# EC2 Instance in Third VPC
resource "aws_instance" "third_instance" {
  provider               = aws.third
  ami                    = data.aws_ami.third_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.third_subnet.id
  vpc_security_group_ids = [aws_security_group.third_sg.id]
  key_name               = var.third_key_name

  user_data = local.third_user_data

  tags = {
    Name        = "Third-VPC-Instance"
    Environment = "Demo"
    Region      = var.third_region
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.third_accepter,
    aws_vpc_peering_connection_accepter.first_accepter
  ]
}