# Creating AWS EC2 instances with distinct AMIs
resource "aws_instance" "web_servers" {
    for_each = {
        web_prod = "ami-0c55b159cbfafe1f0"
        web_dev  = "ami-0ac4df6de4125c3a1"
    }

    ami           = each.value
    instance_type = "t2.micro"

    tags = {
        Name = each.key  # Sets the tag to "web_prod" or "web_dev"
    }
}