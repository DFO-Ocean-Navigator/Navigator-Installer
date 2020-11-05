# Steps for deployment on a Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Debian 10, CentOS 6, and Centos 7.

## Create standard Linux account. Adjust the variable STD_USER_ACCT accordingly.

* STD_USER_ACCT="buildadm"
* groupadd -g 1001 ${STD_USER_ACCT}
* useradd -u 1001 -g 1001 --no-create-home -s /bin/bash ${STD_USER_ACCT}

## (OPTIONAL) If you are wishing to use our Datastore. Please create the /data directory and ensure that the user is set as owner in order for the ${HOME}/bin/mount-remote.sh script to work as stated later in this installation recipe. 

* mkdir /data && chown ${STD_USER_ACCT}:${STD_USER_ACCT} /data

## Change your present working directory to /home and clone the Navigator-Install.git repository.

* cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git ${STD_USER_ACCT}

## Change user and group ownership of the /home/${STD_USER_ACCT} to the ${STD_USER_ACCT} account and become the ${STD_USER_ACCT} user.

* chown -R ${STD_USER_ACCT}:${STD_USER_ACCT} /home/${STD_USER_ACCT}/ ; su - ${STD_USER_ACCT}

## Run the bin/configure.sh script in order to populate the toolchain and checkout various repos both internally and externally

* bash bin/configure.sh

## Source the Ocean Navigator environment file located in tools/conf/ocean-navigator-env.sh in order to have your session's environment variables update.

* source tools/conf/ocean-navigator-env.sh

## Install Node version 8.16.0, use yarn to bring in bower

* nvm install v12.18.4 ; yarn global add bower --prefix=$HOME/tools/bowner --global-folder $(npm prefix -g)

## Change your working directory to Ocean-Data-Map-Project/oceannavigator/frontend, and build the UI

* cd ${HOME}/Ocean-Data-Map-Project/oceannavigator/frontend ; yarn install && yarn build

## (OPTIONAL) If you are using our Datastore please send your request to DFO.OceanNavigator-NavigateurOcean.MPO@dfo-mpo.gc.ca and attach a copy of the Public SSH key generated for the user hosting the Ocean Navigator software.

* ${HOME}/bin/mount-remote.sh

## (OPTIONAL) If you wish to visualize your local datasets. You will need to update the datasetconfig.json and oceannavigator.cfg configuration files.

* cd ${HOME}/Ocean-Data-Map-Project/oceannavigator/configs 
* edit datasetconfig.json
* edit oceannavigator.cfg

## Change back to the Ocean-Data-Map-Project directory and launch the web services.

* cd ${HOME}/Ocean-Data-Map-Project ; ./launch-web-service.sh

# If you wish to use Centos 8 or Fedora 31 you will need to have your system's person install the libnsl library. This package is required by Miniconda to be able to run its various binaries and libraries. To install the libnsl package issue the following dnf install command;

* dnf install libnsl -y
