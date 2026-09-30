resource "aws_vpc" "my-vpc-1" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"

    tags = {
        Name = var.vpc_name
        Env = "Dev"
    }
}

data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my-vpc-1.id
    cidr_block = var.subnet_cidr_block[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    count = 3

    tags = {
        Name = "Public-Subnet-{count.index + 1}"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.my-vpc-1.id

    tags = {
        Name = var.IGW_name
    }
}

resource "aws_route_table" "Public_RT" {
    vpc_id = aws_vpc.my-vpc-1.id

    route {
        cidr_block = var.anywhere_cidr_block
        gateway_id = aws_internet_gateway.IGW.id
    }

    tags = {
        Name = var.public_RT_name
    }
}

resource "aws_route_table_association" "Public_RT_assoc" {
    route_table_id = aws_route_table.Public_RT.id
    subnet_id = aws_subnet.public_subnet[count.index].id
    count = 3
}

resource "aws_security_group" "webserver_SG" {
    vpc_id = aws_vpc.my-vpc-1.id

    tags = {
        Name = var.security_group_name
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_traffic_inbound" {
    security_group_id = aws_security_group.webserver_SG.id
    ip_protocol = "tcp"
    cidr_ipv4 = var.anywhere_cidr_block
    from_port = "80"
    to_port = "80"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_traffic_inbound" {
    security_group_id = aws_security_group.webserver_SG.id
    ip_protocol = "tcp"
    cidr_ipv4 = var.anywhere_cidr_block
    from_port = "22"
    to_port = "22"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic" {
    security_group_id = aws_security_group.webserver_SG.id
    ip_protocol = "-1"
    cidr_ipv4 = var.anywhere_cidr_block
}

resource "aws_key_pair" "LT_key_pair" {
    public_key = var.aws_public_key
    key_name = var.key_pair_name
}

resource "aws_launch_template" "webserver_launch_template" {
    name = var.launch_template_name
    image_id = var.ami_id
    instance_type = var.type_of_instance
    key_name = aws_key_pair.LT_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.webserver_SG.id]
    user_data = base64encode(<<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install httpd -y
                sudo systemctl enable httpd
                sudo systemctl start httpd
                echo "<html><body><p>Server Hostname: $(hostname)</p></body></html>" > /var/www/html/index.html
                EOF
                )
    # network_interfaces {
    #     associate_public_ip_address = true
    #     security_groups = [aws_security_group.webserver_SG.id]
    # }
    depends_on = [ aws_key_pair.LT_key_pair, aws_security_group.webserver_SG ]
    tags = {
        Name = var.launch_template_name
    }
}

resource "aws_autoscaling_group" "my_ASG" {
    name = var.ASG_name
    min_size = 2
    max_size = 4
    desired_capacity = 2
    launch_template {
        id = aws_launch_template.webserver_launch_template.id
    }
    vpc_zone_identifier = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id, aws_subnet.public_subnet[2].id]
}

resource "aws_lb_target_group" "alb_TG" {
    name = var.target_group_name
    port = 80
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = aws_vpc.my-vpc-1.id
}

resource "aws_lb" "my-alb-1" {
    name = var.ALB_name
    internal = false  # internet facing scheme
    load_balancer_type = "application"
    subnets = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id, aws_subnet.public_subnet[2].id]
    security_groups = [aws_security_group.webserver_SG.id]
}

resource "aws_lb_listener" "alb_listener_conf" {
    load_balancer_arn = aws_lb.my-alb-1.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_TG.arn
    }
}

resource "aws_autoscaling_attachment" "asg_attachment_alb" {
  autoscaling_group_name = aws_autoscaling_group.my_ASG.id
  lb_target_group_arn    = aws_lb_target_group.alb_TG.arn
}
