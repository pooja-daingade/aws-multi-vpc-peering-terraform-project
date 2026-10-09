# AWS Multi-VPC Peering using Terraform

## 1. Project Overview

This project demonstrates the implementation of a Multi-VPC Peering Architecture on Amazon Web Services (AWS) using Terraform.

The objective of this project is to create three separate Virtual Private Clouds (VPCs) and establish private network connectivity between them using VPC Peering.

Terraform is used to automate the creation and configuration of AWS networking resources, including VPCs, subnets, Internet Gateways, route tables, VPC Peering connections, security groups, and EC2 instances.

The project follows a full-mesh VPC Peering architecture in which all three VPCs are connected through individual peering connections.

## 2. Project Objectives

- Create three independent VPCs using Terraform.
- Configure a separate CIDR block for each VPC.
- Create public subnets for hosting EC2 instances.
- Configure Internet Gateways and route tables.
- Establish VPC Peering connections between all three VPCs.
- Configure routes for communication between VPCs.
- Configure Security Groups to control network traffic.
- Launch EC2 instances in the respective VPCs.
- Test private connectivity between EC2 instances.
- Understand Infrastructure as Code (IaC) using Terraform.

## 3. Architecture Overview

The architecture consists of three VPCs connected through VPC Peering.

### VPC Configuration

| VPC | VPC CIDR | Subnet CIDR |
|---|---|---|
| First VPC | 10.0.0.0/16 | 10.0.1.0/24 |
| Second VPC | 10.1.0.0/16 | 10.1.1.0/24 |
| Third VPC | 10.2.0.0/16 | 10.2.1.0/24 |

### VPC Peering Connections

The following peering connections are configured:

- First VPC ↔ Second VPC
- Second VPC ↔ Third VPC
- Third VPC ↔ First VPC


Each VPC has a separate CIDR block to avoid overlapping IP address ranges.

## 4. AWS Services Used

### Amazon VPC
Used to create isolated virtual networks for the three environments.

### VPC Peering
Used to establish private network connectivity between VPCs through their private IP addresses.

### Amazon EC2
Used to launch virtual machines inside the public subnets for connectivity testing.

### Internet Gateway
Used to provide internet connectivity to resources through the configured public-subnet routes.

### Route Tables
Used to define how network traffic is routed between local VPC resources, peered VPCs, and the internet.

### Security Groups
Used to control inbound and outbound traffic for EC2 instances.

### Terraform
Used to define, provision, and manage AWS infrastructure as code.

## 5. Terraform Implementation

The infrastructure is defined using Terraform configuration files.

### main.tf
Contains the primary infrastructure resources, including VPCs, subnets, Internet Gateways, route tables, VPC Peering connections, routes, Security Groups, and EC2 instances.

### providers.tf
Defines the AWS provider configurations used to manage resources in the respective VPCs.

### variables.tf
Defines input variables such as VPC CIDR blocks and subnet CIDR blocks.

### terraform.tfvars
Contains the values assigned to the Terraform input variables.

### outputs.tf
Defines useful outputs such as VPC IDs, EC2 instance IDs, private IP addresses, public IP addresses, and VPC Peering connection details.

## 6. Network Configuration

Each VPC has its own network configuration.

### First VPC
- VPC CIDR: 10.0.0.0/16
- Subnet CIDR: 10.0.1.0/24
- EC2 instance deployed in the subnet.
- Route table configured for local and external network routing.
- Peering routes configured for the second and third VPCs.

### Second VPC
- VPC CIDR: 10.1.0.0/16
- Subnet CIDR: 10.1.1.0/24
- EC2 instance deployed in the subnet.
- Route table configured for local and external network routing.
- Peering routes configured for the first and third VPCs.

### Third VPC
- VPC CIDR: 10.2.0.0/16
- Subnet CIDR: 10.2.1.0/24
- EC2 instance deployed in the subnet.
- Route table configured for local and external network routing.
- Peering routes configured for the first and second VPCs.

## 7. VPC Peering Configuration

VPC Peering enables private communication between two VPCs using private IP addresses.

In this project, three peering connections are configured to connect all three VPCs.

### Peering Connection 1
First VPC to Second VPC.

### Peering Connection 2
Second VPC to Third VPC.

### Peering Connection 3
Third VPC to First VPC.

Each peering connection requires the appropriate routes in both participating VPC route tables.

VPC Peering does not automatically add routes to route tables. The necessary routes must be configured separately.

Security Groups must also allow the required traffic for successful communication.

## 8. Route Table Configuration

Route tables control how traffic travels between network destinations.

The project includes:

- Local routes for communication within each VPC.
- Internet Gateway routes for internet-bound traffic.
- Peering routes for communication with the other two VPCs.

The peering routes use the destination VPC CIDR and the corresponding VPC Peering connection as the target.

For example:

| Source VPC | Destination CIDR | Target |
|---|---|---|
| First VPC | 10.1.0.0/16 | First-to-Second Peering |
| First VPC | 10.2.0.0/16 | Third-to-First Peering |
| Second VPC | 10.0.0.0/16 | First-to-Second Peering |
| Second VPC | 10.2.0.0/16 | Second-to-Third Peering |
| Third VPC | 10.0.0.0/16 | Third-to-First Peering |
| Third VPC | 10.1.0.0/16 | Second-to-Third Peering |

These routes enable the VPCs to direct traffic toward their peered networks.

## 9. Security Group Configuration

Security Groups control traffic to and from the EC2 instances.

The project configures Security Groups to allow the required network traffic.

### Inbound Rules
- SSH traffic for instance administration.
- ICMP traffic for ping-based connectivity testing.
- TCP traffic from the configured VPC CIDR ranges, as required by the lab.

### Outbound Rules
Outbound traffic is configured according to the Terraform Security Group rules.

For a production environment, inbound SSH access should be restricted to trusted IP addresses instead of allowing access from anywhere.

## 10. EC2 Instance Deployment

Three EC2 instances are deployed, with one instance in each VPC.

| EC2 Instance | VPC | Private IP |
|---|---|---|
| First Instance | First VPC | 10.0.1.178 |
| Second Instance | Second VPC | 10.1.1.195 |
| Third Instance | Third VPC | 10.2.1.131 |

Private IP addresses are used to test communication between instances across the peered VPCs.

## 11. Connectivity Testing

Connectivity between EC2 instances can be tested using the ping command.