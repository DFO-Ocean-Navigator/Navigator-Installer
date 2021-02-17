#!/usr/bin/env bash

ssh-keygen -R hank.research.cs.dal.ca -f ${HOME}/.ssh/known_hosts
ssh-keyscan -4 -f ${HOME}/.ssh/known_hosts -t rsa hank.research.cs.dal.ca

sshfs -o Ciphers=aes256-gcm@openssh.com,ro,reconnect,allow_other,ServerAliveInterval=15,ServerAliveCountMax=3 on-buildadm@hank.research.cs.dal.ca:/tank/data /data
