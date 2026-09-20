variable "ec2_instance_type" {
    description = "EC2 Instance type"
    type = list(string)
    default = ["t3.micro", "t3.small", "m7i-flex.large"]
}

variable "aws_region_123" {
    description = "Region of AWS resources"
    type = string
    default = "ap-south-1"
}

variable "ec2_ami_id" {
    description = "AMI ID"
    type = string
    default = "ami-066c4849e6b3a1e3d"
}

variable "Access_key_ID" {
    type = string
    sensitive = true
}

variable "Secret_access_key" {
    type = string
    sensitive = true
}