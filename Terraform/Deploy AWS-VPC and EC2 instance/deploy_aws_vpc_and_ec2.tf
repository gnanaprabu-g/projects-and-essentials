terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
#  access_key = "access-key-from-IAM"
#  secret_key = "secret-key-from-IAM"
}

# Create VPC
resource "aws_vpc" "test_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "test_vpc"
    }
}

# Fetch all currently available AZs in your active region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create Public subnet 1
resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "Public_Subnet_1"
    }
}

# Create Public subnet 2
resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true

    tags = {
        Name = "Public_Subnet_2"
    }
}

# Create Private subnet 1
resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "Private_Subnet_1"
    }
}

# Create Private subnet 2
resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = data.aws_availability_zones.available.names[1]

    tags = {
        Name = "Private_Subnet_2"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "test_IGW" {
    vpc_id = aws_vpc.test_vpc.id

    tags = {
        Name = "Test-IGW"
    }
}

# Create Public route table and add route to Internet Gateway
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_IGW.id
  }

  tags = {
    Name = "Public-RT"
  }
}

# Associate Public subnets to Public route table 
resource "aws_route_table_association" "pub_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.Public_RT.id
}

resource "aws_route_table_association" "pub_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.Public_RT.id
}

# Create the NAT Gateway and attach the EIP
resource "aws_nat_gateway" "nat_GW" {
  availability_mode = "regional"
  vpc_id = aws_vpc.test_vpc.id
  connectivity_type = "public"

  tags = {
    Name = "NAT-gateway"
  }

  # Good practice to ensure infrastructure order is respected
  depends_on = [aws_internet_gateway.test_IGW]
}

# Allocate the Elastic IP (EIP)
# resource "aws_eip" "nat_eip" {
#   domain = "vpc"

#   # Ensures correct ordering so the EIP can be provisioned successfully
#   depends_on = [aws_nat_gateway.nat_GW]

#   tags = {
#     Name = "nat-gateway-eip"
#   }
# }

# Create Private route table and add route to NAT Gateway
resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_GW.id
  }

  tags = {
    Name = "Private-RT"
  }
}

# Associate Private subnets to Private route table 
resource "aws_route_table_association" "pvt_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.Private_RT.id
}

resource "aws_route_table_association" "pvt_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.Private_RT.id
}

# Create Security group in Public Subnet
resource "aws_security_group" "ssh_SG" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "ssh_SG"
  }
}

# Create SSH inbound rule in Security Group
resource "aws_vpc_security_group_ingress_rule" "allow_SSH_inbound" {
  security_group_id = aws_security_group.ssh_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Create onbound rule in Security Group
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_ipv4" {
  security_group_id = aws_security_group.ssh_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create Network Interface for EC2 in Public subnet 1 and attach Security group to it.
resource "aws_network_interface" "net_Interface_pub" {
  subnet_id   = aws_subnet.public_subnet_1.id
  private_ips = ["10.0.1.100"]
  security_groups = [aws_security_group.ssh_SG.id]

  tags = {
    Name = "network_interface_pub_1"
  }
}




# Create EC2 instance in Public subnet
# a. Generate a secure private key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# b. Create the AWS Key Pair and upload the generated public key
resource "aws_key_pair" "deployed_key" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# c. Save the private key locally to a .pem file for SSH access
resource "local_file" "ssh_key" {
  filename        = "${path.module}/my-terraform-key.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400" # Restricts permissions automatically
}

# d. Deploy the EC2 Instance using the Key Pair
resource "aws_instance" "Terraform-EC2-Public" {
  ami           = "ami-07b8342387d78d5bb" # Amazon Linux 2023 kernel-6.18 AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployed_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install python-pip -y
              sudo pip install ansible
              sudo yum install java-17-amazon-corretto-devel -y
              EOF

  primary_network_interface {
    network_interface_id = aws_network_interface.net_Interface_pub.id
  }

  tags = {
    Name = "Terraform-EC2-Public"
  }
}

# Create Network Interface for EC2 in Private subnet 2
resource "aws_network_interface" "net_Interface_pvt" {
  subnet_id   = aws_subnet.private_subnet_2.id
  private_ips = ["10.0.4.100"]

  tags = {
    Name = "network_interface_pvt_2"
  }
}




# Create EC2 instance in Private subnet 2
# a. Generate a secure private key
resource "tls_private_key" "ec2_key_pvt" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# b. Create the AWS Key Pair and upload the generated public key
resource "aws_key_pair" "deployed_key_pvt" {
  key_name   = "my-terraform-key_pvt"
  public_key = tls_private_key.ec2_key_pvt.public_key_openssh
}

# c. Save the private key locally to a .pem file for SSH access
resource "local_file" "ssh_key_pvt" {
  filename        = "${path.module}/my-terraform-key_pvt.pem"
  content         = tls_private_key.ec2_key_pvt.private_key_pem
  file_permission = "0400" # Restricts permissions automatically
}

# d. Deploy the EC2 Instance using the Key Pair
resource "aws_instance" "Terraform-EC2-Private" {
  ami           = "ami-07b8342387d78d5bb" # Amazon Linux 2023 kernel-6.18 AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployed_key_pvt.key_name
#  vpc_security_group_ids = [aws_security_group.ssh_SG.id]   # Choosing Default SG

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install python-pip -y
              sudo pip install ansible
              sudo yum install java-17-amazon-corretto-devel -y
              EOF

  primary_network_interface {
    network_interface_id = aws_network_interface.net_Interface_pvt.id
  }

  tags = {
    Name = "Terraform-EC2-Private"
  }
}

# Create data lookup for VPC default SG
data "aws_security_group" "vpc_default_SG" {
  vpc_id = aws_vpc.test_vpc.id
  name   = "default"
}

# Update SSH inbound rule in VPC default Security Group
resource "aws_vpc_security_group_ingress_rule" "allow_SSH_inbound_pvt" {
  security_group_id = data.aws_security_group.vpc_default_SG.id
  referenced_security_group_id = aws_security_group.ssh_SG.id
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Note: Manually remove the above security group reference in AWS console before "terraform destroy" command
