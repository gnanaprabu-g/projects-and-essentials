variable "ec2_instance_tags" {
    description = "EC2 Instance Tags"
    type = map(string)
    default = {
        "Name" = "ec2-web"
        "Tier" = "web"
    }
}

variable "ec2_instance_type_map" {
    description = "EC2 Instance type Map"
    type = map(string)
    default = {
        "tiny-apps" = "t3.micro"
        "midsize-apps" = "t3.small"
        "big-apps" = "m7i-flex.large"
    }
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