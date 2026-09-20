resource "aws_instance" "my_ec2_instance" {
    ami = var.ec2_ami_id
    instance_type = var.ec2_instance_type
    count = var.ec2_instance_count

    tags = {
        Name = "My-EC2-vm-${count.index}"
    }  
}