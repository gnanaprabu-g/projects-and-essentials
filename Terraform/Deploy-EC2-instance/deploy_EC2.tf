terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
#  access_key = "access-key-from-IAM"
#  secret_key = "secret-key-from-IAM"
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "aws_security_group" "existing_sg" {
  name = "ALL-TCP"
}

# 1. Generate a secure private key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Create the AWS Key Pair and upload the generated public key
resource "aws_key_pair" "deployed_key" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# 3. Save the private key locally to a .pem file for SSH access
resource "local_file" "ssh_key" {
  filename        = "${path.module}/my-terraform-key.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400" # Restricts permissions automatically
}

# 4. Deploy the EC2 Instance using the Key Pair
resource "aws_instance" "Terraform-EC2" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployed_key.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install python-pip -y
              sudo pip install ansible
              sudo yum install java-17-amazon-corretto-devel -y
              EOF

  tags = {
    Name = "Terraform-EC2"
  }
}