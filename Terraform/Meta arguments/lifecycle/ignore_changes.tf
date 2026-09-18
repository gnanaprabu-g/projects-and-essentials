resource "aws_vpc" "my_vpc_1" {
    cidr_block = "10.0.0.0/16"

    tags = {
        "Name" = "terraform-vpc-mumbai"
        "Environment" = "Dev"
    }

    lifecycle {
        ignore_changes = [tags]
    }
}