# Leveraging high availability by creating an AWS Auto scaling group & application load balancer
Lets create resources with required parameters in the below order:

1. VPC creation,
    a. name
    b. cidr_block
    c. tenancy

2. Subnet creation,
    a. name
    b. availability_zone
    c. cidr_block

3. Internet Gateway creation,
    a. name
    b. vpc_name

4. Route table - public creation,
    a. name
    b. route_to_IGW
    c. subnet_associations

5. Security Group creation,
    a. name
    b. vpc_name
    c. inbound_rules
        i. allow_inbound_http_tcp_80
        ii. allow_inbound_ssh_tcp_22
        iii. allow_all_outbound_traffic

6. Launch Template creation,
    a. name
    b. AMI
    c. instance_type
    d. key_pair
        i. generate public and private keys using below command in linux
            ssh-keygen -t rsa -b 4096
        ii. pass public key (/root/.ssh/id_rsa.pub) contents to "public_key" parameter in "aws_key_pair" creation block
        iii. retain private key (/root/.ssh/id_rsa) as "key.pem" file in local
    e. security_group_name
    f. bash_script for httpd setup

7. Auto Scaling Group - ASG creation,
    a. name
    b. launch_template
    c. vpc_name
    d. subnets
    e. capacity
        i. desired_capacity
        ii. minimum_capacity
        iii. maximum_capacity

8. Target groups creation,
    a. name
    b. direct traffic to HTTP | port 80, so make sure the ‘Protocol’ is HTTP
    b. target_type set to ec2_instances

9. Application Load Balancer - ALB creation,
    a. name
    b. scheme
    c. vpc_name
    d. subnets
    e. security_group_name
    f. forward the listener to target_groups_name

10. Add ALB to Auto Scaling Group - ASG,
    a. ALB_name
    b. target_groups_name