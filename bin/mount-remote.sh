#!/usr/bin/env bash

ssh-keyscan -4 -t rsa hank.research.cs.dal.ca >> /home/buildadm/.ssh/known_hosts

sshfs -o reconnect on-buildadm@hank.research.cs.dal.ca:/tank/data /data
