# Steps for deployment on a Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Debian 10, CentOS 6, and Centos 7.

## Create standard Linux account.

* groupadd -g 1001 buildadm
* useradd -u 1001 -g 1001 --no-create-home -s /bin/bash buildadm

## Change your present working directory to /home and clone the Navigator-Install.git.

* cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git buildadm

## Change your present working directory to buildadm initialize, fetch and checkout any nested submodules run the following command;

* cd buildadm ; git submodule update --init --recursive

## Change user and group ownership of the /home/buildadm to the buildadm account and become the buildadm user.

* chown -R buildadm:buildadm /home/buildadm/ ; su - buildadm

## Install Node version 8.16.0, use yarn to bring in bower

* nvm install v8.16.0 ; yarn global add bower

## Change your working directory to Ocean-Data-Map-Project/oceannavigator/frontend, and build the UI

* cd Ocean-Data-Map-Project/oceannavigator/frontend ; yarn install && yarn build

## Change the folling lines in the Ocean-Data-Map-Project/oceannavigator/oceannavigator.cfg file. By using the following strings 10.0.3.56,10.0.3.9 to navigator.oceansdata.ca.

* sed -i 's/10.0.3.56/navigator.oceansdata.ca/;s/10.0.3.9/navigator.oceansdata.ca/' ~/Ocean-Data-Map-Project/oceannavigator/oceannavigator.cfg

## Change back to the Ocean-Data-Map-Project directory and launch the web services.

* cd ~/Ocean-Data-Map-Project ; ./launch-web-service.sh

## Administrative housekeeping tasks

* chmod 600 ${HOME}/.conf/.passwd-s3

# If you wish to use Centos 8 or Fedora 31 you will need to have your system's person install the libnsl library. This package is required by Miniconda to be able to run its various binaries and libraries. To install the libnsl package issue the following dnf install command;

* dnf install libnsl -y
