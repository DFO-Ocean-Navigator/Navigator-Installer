# Steps for deployment on a Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Debian 10, CentOS 6, and Centos 7.

## Create standard Linux account.

* STD_USER_ACCT="${STD_USER_ACCT}"
* groupadd -g 1001 ${STD_USER_ACCT}
* useradd -u 1001 -g 1001 --no-create-home -s /bin/bash ${STD_USER_ACCT}

## (OPTIONAL) If you are wishing to use our Datastore. Please create the /data directory and ensure that the user is set as owner in order for the ${HOME}/bin/mount-remote.sh script to work as stated later in this installation recipe. 

* mkdir /data && chown ${STD_USER_ACCT}:${STD_USER_ACCT} /data

## Change your present working directory to /home and clone the Navigator-Install.git.

* cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git ${STD_USER_ACCT}

## Change your present working directory to ${STD_USER_ACCT} initialize, fetch and checkout any nested submodules run the following command;

* cd ${STD_USER_ACCT} ; git submodule update --init --recursive

## Change user and group ownership of the /home/${STD_USER_ACCT} to the ${STD_USER_ACCT} account and become the ${STD_USER_ACCT} user.

* chown -R ${STD_USER_ACCT}:${STD_USER_ACCT} /home/${STD_USER_ACCT}/ ; su - ${STD_USER_ACCT}

## Install Node version 8.16.0, use yarn to bring in bower

* nvm install v8.16.0 ; yarn global add bower

## Change your working directory to Ocean-Data-Map-Project/oceannavigator/frontend, and build the UI

* cd ${HOME}/Ocean-Data-Map-Project/oceannavigator/frontend ; yarn install && yarn build

## Depening on location. You should either use the main branch in order to run in production (which is default). Or change to the off-site branch which is recommended for every other use case.

* cd ${HOME}/Ocean-Data-Map-Project/oceannavigator/configs ; git checkout off-site

## (OPTIONAL) If you are using our Datastore please send your request to DFO.OceanNavigator-NavigateurOcean.MPO@dfo-mpo.gc.ca and attach a copy of the Public SSH key generated for the user hosting the Ocean Navigator software.

* ${HOME}/bin/mount-remote.sh

## Change back to the Ocean-Data-Map-Project directory and launch the web services.

* cd ${HOME}/Ocean-Data-Map-Project ; ./launch-web-service.sh

# If you wish to use Centos 8 or Fedora 31 you will need to have your system's person install the libnsl library. This package is required by Miniconda to be able to run its various binaries and libraries. To install the libnsl package issue the following dnf install command;

* dnf install libnsl -y
