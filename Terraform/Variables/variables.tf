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

variable "ec2_instance_count" {
    description = "EC2 Instance Count"
    type = number
    default = 1
}

variable "ec2_instance_type" {
    description = "EC2 Instance Type"
    type = string
    default = "t3.micro"
}

variable "Access_key_ID" {
    type = string
    sensitive = true
}

variable "Secret_access_key" {
    type = string
    sensitive = true
}

# Declare the above sensitive variables in .bashrc file as shown below,
# export TF_VAR_Access_key_ID="abcdefghijklmnopqrst"
# export TF_VAR_Secret_access_key="abcd1234567890efgh!@1234567890ijklmnop"
# Then run "source .bashrc" to update the environment variables.