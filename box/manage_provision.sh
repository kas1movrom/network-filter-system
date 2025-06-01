#!/bin/bash

ssh-keygen 

mkdir -p ~/mephi/{ansible,chef,puppet,salt}

curl -fsSL https://repo.saltproject.io/py3/redhat/9/x86_64/latest.repo > /etc/yum.repos.d/salt.repo
curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P chef-workstation


dnf install -y git vim ansible epel-release https://yum.puppet.com/puppet7-release-el-9.noarch.rpm puppetserver salt-master

systemctl start salt-master
systemctl start puppetserver