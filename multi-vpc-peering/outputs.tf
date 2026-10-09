# Outputs for 3 VPC Peering Demo

# First VPC
output "first_vpc_id" {
  description = "ID of the First VPC"
  value       = aws_vpc.first_vpc.id
}

output "first_vpc_cidr" {
  description = "CIDR block of the First VPC"
  value       = aws_vpc.first_vpc.cidr_block
}

# Second VPC
output "second_vpc_id" {
  description = "ID of the Second VPC"
  value       = aws_vpc.second_vpc.id
}

output "second_vpc_cidr" {
  description = "CIDR block of the Second VPC"
  value       = aws_vpc.second_vpc.cidr_block
}

# Third VPC
output "third_vpc_id" {
  description = "ID of the Third VPC"
  value       = aws_vpc.third_vpc.id
}

output "third_vpc_cidr" {
  description = "CIDR block of the Third VPC"
  value       = aws_vpc.third_vpc.cidr_block
}


# VPC Peering Connections

output "first_to_second_peering_id" {
  description = "ID of First to Second VPC Peering Connection"
  value       = aws_vpc_peering_connection.first_to_second.id
}

output "second_to_third_peering_id" {
  description = "ID of Second to Third VPC Peering Connection"
  value       = aws_vpc_peering_connection.second_to_third.id
}

output "third_to_first_peering_id" {
  description = "ID of Third to First VPC Peering Connection"
  value       = aws_vpc_peering_connection.third_to_first.id
}


# Peering Status

output "first_to_second_peering_status" {
  description = "Status of First to Second VPC Peering Connection"
  value       = aws_vpc_peering_connection.first_to_second.accept_status
}

output "second_to_third_peering_status" {
  description = "Status of Second to Third VPC Peering Connection"
  value       = aws_vpc_peering_connection.second_to_third.accept_status
}

output "third_to_first_peering_status" {
  description = "Status of Third to First VPC Peering Connection"
  value       = aws_vpc_peering_connection.third_to_first.accept_status
}


# EC2 Instance IDs

output "first_instance_id" {
  description = "ID of the First VPC EC2 Instance"
  value       = aws_instance.first_instance.id
}

output "second_instance_id" {
  description = "ID of the Second VPC EC2 Instance"
  value       = aws_instance.second_instance.id
}

output "third_instance_id" {
  description = "ID of the Third VPC EC2 Instance"
  value       = aws_instance.third_instance.id
}


# EC2 Private IPs

output "first_instance_private_ip" {
  description = "Private IP of the First EC2 Instance"
  value       = aws_instance.first_instance.private_ip
}

output "second_instance_private_ip" {
  description = "Private IP of the Second EC2 Instance"
  value       = aws_instance.second_instance.private_ip
}

output "third_instance_private_ip" {
  description = "Private IP of the Third EC2 Instance"
  value       = aws_instance.third_instance.private_ip
}


# EC2 Public IPs

output "first_instance_public_ip" {
  description = "Public IP of the First EC2 Instance"
  value       = aws_instance.first_instance.public_ip
}

output "second_instance_public_ip" {
  description = "Public IP of the Second EC2 Instance"
  value       = aws_instance.second_instance.public_ip
}

output "third_instance_public_ip" {
  description = "Public IP of the Third EC2 Instance"
  value       = aws_instance.third_instance.public_ip
}


# Connectivity Test Commands

output "test_connectivity_commands" {
  description = "Commands to test connectivity between all three VPCs"
  value = <<-EOT

    VPC PEERING CONNECTIVITY TEST

    1. First → Second:
       SSH into First EC2:
       ssh -i <first-key.pem> ubuntu@${aws_instance.first_instance.public_ip}
       ping ${aws_instance.second_instance.private_ip}

    2. Second → Third:
       SSH into Second EC2:
       ssh -i <second-key.pem> ubuntu@${aws_instance.second_instance.public_ip}
       ping ${aws_instance.third_instance.private_ip}

    3. Third → First:
       SSH into Third EC2:
       ssh -i <third-key.pem> ubuntu@${aws_instance.third_instance.public_ip}
       ping ${aws_instance.first_instance.private_ip}

  EOT
}