#!/bin/bash

useradd -m roman
usermod -aG wheel roman

dnf install -y salt-minion

systemctl start salt-minion

