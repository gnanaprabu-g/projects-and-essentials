variable "aws_region" {
    type = string
}

variable "Access_key_ID" {
    type = string
    sensitive = true
}

variable "Secret_access_key" {
    type = string
    sensitive = true
}

variable "vpc_name" {
    type = string
}

variable "vpc_cidr_block" {
    type = string  
}

variable "anywhere_cidr_block" {
    type = string
    default = "0.0.0.0/0"
}

variable "subnet_cidr_block" {
    type = list(string)
}

variable "IGW_name" {
    type = string
}

variable "public_RT_name" {
    type = string
}

variable "security_group_name" {
    type = string
}

variable "launch_template_name" {
    type = string
}

variable "ami_id" {
    type = string
}

variable "type_of_instance" {
    type = string
}

variable "key_pair_name" {
    type = string
}

variable "aws_public_key" {
    type = string
}

variable "ASG_name" {
    type = string
}

variable "target_group_name" {
    type = string
}

variable "ALB_name" {
    type = string
}
