#!/usr/bin/env bash

ssh-keygen -R hank.research.cs.dal.ca -f ${HOME}/.ssh/known_hosts
ssh-keyscan -4 -t rsa hank.research.cs.dal.ca -f ${HOME}/.ssh/known_hosts

sshfs -o ro,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 on-buildadm@hank.research.cs.dal.ca:/tank/data /data
