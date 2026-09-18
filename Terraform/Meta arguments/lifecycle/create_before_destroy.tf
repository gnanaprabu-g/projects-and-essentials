resource "aws_vpc" "my_vpc_1" {
    cidr_block = "13.0.0.0/16"

    tags = {
        "Name" = "terraform-vpc-mumbai"
    }

    lifecycle {
        create_before_destroy = true
    }
}