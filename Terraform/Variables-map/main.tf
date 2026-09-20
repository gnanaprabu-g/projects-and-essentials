resource "aws_instance" "my_ec2_instance" {
    ami = var.ec2_ami_id
    instance_type = var.ec2_instance_type_map["midsize-apps"]
    count = 1

    tags = var.ec2_instance_tags 
}