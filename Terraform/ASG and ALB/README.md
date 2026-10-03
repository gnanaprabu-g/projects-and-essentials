# Leveraging high availability by creating an AWS Auto scaling group & application load balancer
Lets create resources with required parameters in the below order:

1. VPC creation,
    1. name
    2. cidr_block
    3. tenancy

2. Subnet creation,
    1. name
    2. availability_zone
    3. cidr_block

3. Internet Gateway creation,
    1. name
    2. vpc_name

4. Route table - public creation,
    1. name
    2. route_to_IGW
    3. subnet_associations

5. Security Group creation,
    1. name
    2. vpc_name
    3. inbound_rules
        1. allow_inbound_http_tcp_80
        2. allow_inbound_ssh_tcp_22
        3. allow_all_outbound_traffic

6. Launch Template creation,
    1. name
    2. AMI
    3. instance_type
    4. key_pair
        1. generate public and private keys using below command in linux
            1. `ssh-keygen -t rsa -b 4096`
        2. pass public key (/root/.ssh/id_rsa.pub) contents to "public_key" parameter in "aws_key_pair" creation block
        3. retain private key (/root/.ssh/id_rsa) as "key.pem" file in local
    5. security_group_name
    6. bash_script for httpd setup

7. Auto Scaling Group - ASG creation,
    1. name
    2. launch_template
    3. vpc_name
    4. subnets
    5. capacity
        1. desired_capacity
        2. minimum_capacity
        3. maximum_capacity

8. Target groups creation,
    1. name
    2. direct traffic to HTTP | port 80, so make sure the ‘Protocol’ is HTTP
    3. target_type set to ec2_instances

9. Application Load Balancer - ALB creation,
    1. name
    2. scheme
    3. vpc_name
    4. subnets
    5. security_group_name
    6. forward the listener to target_groups_name

10. Add ALB to Auto Scaling Group - ASG,
    1. ALB_name
    2. target_groups_name