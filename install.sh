#!/usr/bin/env bash

sudo groupadd -g 1001 buildadm
sudo useradd -u 1001 -g 1001 --no-create-home -s /bin/bash buildadm

cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git buildadm

cd buildadm ; git submodule update --init --recursive

sudo chown -R buildadm:buildadm /home/buildadm/ ; su - buildadm

nvm install v8.16.0 ; yarn global add bower

cd Ocean-Data-Map-Project/oceannavigator/frontend ; yarn install && yarn build

sed -i 's/10.0.3.56/navigator.oceansdata.ca/;s/10.0.3.9/dory-dev.cs.dal.ca/' ~/Ocean-Data-Map-Project/oceannavigator/oceannavigator.cfg

cd ~/Ocean-Data-Map-Project ; ./launch-web-service.sh
