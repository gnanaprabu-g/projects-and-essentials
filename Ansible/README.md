# Ansible setup and commands

1. We will be installing ansible only in control node.
2. Ansible has Python dependency
3. Issue command in "control node" to run it in all the "managed nodes"
4. Push based and agentless

# setup in EC2 - control node
yum install python-pip -y

sudo pip install ansible

# setup in EC2 - managed node
yum install python-pip -y

# At control node
1. vim inv.txt

```bash
[apache]
10.1.17.28
100.23.12.1
[abc]
22.31.200.82
[debug]
210.34.52.114
152.62.84.7
[play]
41.27.152.28
97.53.74.118
156.77.61.146
```

Note: These can be Public IP or Private IP of managed EC2 servers.

2. vim ansible.cfg

Refer: https://gist.github.com/wbcurry/f38bc6d8d1ee4a70ee2c

3. ansible --version


# Adhoc commands
ansible all -i inv.txt -m ping

ansible all -i inv.txt -a "uname"

ansible all -i inv.txt -a "uname -a"

ansible abc -i inv.txt -m ping

ansible apache -i inv.txt -m yum -a "name=httpd state=present" -b

ansible apache -i inv.txt -m service -a "name=httpd state=started" -b

vim index.html

ansible apache -i inv.txt -m copy -a "src=/home/ec2-user/index.html dest=/var/www/html/index.html" -b


# Playbook commands
vim playbook.yml

ansible-playbook -i inv.txt playbook.yml --syntax-check

ansible-playbook -i inv.txt playbook.yml

ansible-playbook -i inv.txt playbook-tags.yml --tags=copy

ansible-playbook -i inv.txt playbook-tags.yml --skip-tags=copy


# Vault commands
Store the sensitive files (user.txt) in encrypted format.

ansible-vault encrypt user.txt

ansible-playbook -i inv.txt playbook-variable-file.yml --ask-vault-pass

ansible-vault view user.txt

ansible-vault decrypt user.txt


# Roles commands - code resuablity
ansible-galaxy init role_name

sudo yum install tree -y

tree role_name

cat role_name/tasks/main.yml

cat role_name/files/index.html

cat role_name/handlers/main.yml

ansible-playbook -i inv.txt playbook-roles.yml