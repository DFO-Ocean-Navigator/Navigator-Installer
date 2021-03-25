#!/usr/bin/env bash

ssh-keygen -R hank.research.cs.dal.ca -f ${HOME}/.ssh/known_hosts
ssh-keyscan -4 -t rsa hank.research.cs.dal.ca | tee -a ${HOME}/.ssh/known_hosts

sshfs -o Cipher=chacha20-poly1305@openssh.com,ro,reconnect,allow_other,ServerAliveInterval=15,ServerAliveCountMax=3 on-buildadm@hank.research.cs.dal.ca:/tank/data /data
