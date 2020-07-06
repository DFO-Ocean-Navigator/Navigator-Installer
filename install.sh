#!/usr/bin/env bash

STD_USER_ACCT="testing"

groupadd -g 1001 ${STD_USER_ACCT}
useradd -u 1001 -g 1001 --no-create-home -s /bin/bash ${STD_USER_ACCT}

cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git ${STD_USER_ACCT}

cd ${STD_USER_ACCT} ; git submodule update --init --recursive

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/${STD_USER_ACCT}/miniconda/3/amd64

chown -R ${STD_USER_ACCT}:${STD_USER_ACCT} /home/${STD_USER_ACCT}/ 

sed -i "s/buildadm/${STD_USER_ACCT}/" /home/${STD_USER_ACCT}/.bashrc

su - ${STD_USER_ACCT} -c "/home/dwayne/miniconda/3/amd64/bin/conda create --name navigator --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/navigator-spec-file.txt"
su - ${STD_USER_ACCT} -c "/home/dwayne/miniconda/3/amd64/bin/conda create --name index-tool --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/index-tool-spec-file.txt"
su - ${STD_USER_ACCT} -c "/home/dwayne/miniconda/3/amd64/bin/conda create --name nco-tools --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/nco-tools-spec-file.txt"
su - ${STD_USER_ACCT} -c "/home/dwayne/miniconda/3/amd64/bin/conda create --name devops --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/devops-spec-file.txt"
su - ${STD_USER_ACCT} -c ". /home/${STD_USER_ACCT}/.bashrc ; nvm install v8.16.0 ; yarn global add bower"

su - ${STD_USER_ACCT} -c ". /home/${STD_USER_ACCT}/.bashrc ; cd /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/oceannavigator/frontend ; yarn install && yarn build"

if [ ! -d /data ] && [ -f /home/${STD_USER_ACCT}/.ssh/id_rsa ] ; then
   mkdir /data && chown ${STD_USER_ACCT}:${STD_USER_ACCT} /data
   su - ${STD_USER_ACCT} -c "/home/${STD_USER_ACCT}/bin/mount-remote.sh"
else
   echo ""
   echo "   SSH key pair does not exist. Skipping the configuration and execution of SSHFS to remote Datastore."
   echo ""
fi

echo ""
echo "   Software installation has completed. Now become the ${STD_USER_ACCT} user and change your current working"
echo "   directory to Ocean-Data-Map-Project and then run the bin/launch-web-service.sh script."
echo ""
