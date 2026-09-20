resource "aws_instance" "my_ec2_instance" {
    ami = var.ec2_ami_id
    instance_type = var.ec2_instance_type[2]
    count = 2

    tags = {
        Name = "My-EC2-instance-${count.index}"
    }  
}