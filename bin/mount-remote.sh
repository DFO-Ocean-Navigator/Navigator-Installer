#!/usr/bin/env bash

if [ ! -d /data ] ; then
    echo "Please have an admin create the /data directory and that ownership be given to ubuntu."
    exit 1
fi

sshfs -o Cipher=chacha20-poly1305@openssh.com,ro,reconnect,allow_other,ServerAliveInterval=15,ServerAliveCountMax=3 on-buildadm@hank.research.cs.dal.ca:/tank/data /data
