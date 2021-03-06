#!/usr/bin/env bash

STD_USER_ACCT="buildadm"

groupadd -g 1001 ${STD_USER_ACCT}
useradd -u 1001 -g 1001 --no-create-home -s /bin/bash ${STD_USER_ACCT}

cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git ${STD_USER_ACCT}

cd ${STD_USER_ACCT} ; git submodule update --init --recursive

[ -d /home/${STD_USER_ACCT}/tools/miniconda ] && rm -rf /home/${STD_USER_ACCT}/tools/miniconda

bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/${STD_USER_ACCT}/tools/miniconda/3/amd64

chown -R ${STD_USER_ACCT}:${STD_USER_ACCT} /home/${STD_USER_ACCT}/ 

su - ${STD_USER_ACCT} -c "/home/${STD_USER_ACCT}/tools/miniconda/3/amd64/bin/conda create --name navigator --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/navigator-spec-file.txt"
su - ${STD_USER_ACCT} -c "/home/${STD_USER_ACCT}/tools/miniconda/3/amd64/bin/conda create --name index-tool --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/index-tool-spec-file.txt"
su - ${STD_USER_ACCT} -c "/home/${STD_USER_ACCT}/tools/miniconda/3/amd64/bin/conda create --name nco-tools --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/nco-tools-spec-file.txt"
su - ${STD_USER_ACCT} -c "/home/${STD_USER_ACCT}/tools/miniconda/3/amd64/bin/conda create --name devops --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/devops-spec-file.txt"
su - ${STD_USER_ACCT} -c "/home/${STD_USER_ACCT}/tools/miniconda/3/amd64/bin/conda create --name devops --file /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/config/conda/devops-spec-file.txt"

if [ ! -d /data ] && [ -f /home/${STD_USER_ACCT}/.ssh/id_rsa ] ; then
   mkdir /data && chown ${STD_USER_ACCT}:${STD_USER_ACCT} /data
   su - ${STD_USER_ACCT} -c "/home/${STD_USER_ACCT}/bin/mount-remote.sh"
else
   echo ""
   echo "   SSH key pair does not exist. Skipping the configuration and execution of SSHFS to remote Datastore."
   echo ""
fi

echo ""
echo "   Supporting software installation and environment setup has completed. Now become the ${STD_USER_ACCT} user"
echo "   and perform the following steps:"
echo ""
echo "   - run the bin/configure.sh script to alter directory locations"
echo "       * bin/configure.sh"
echo ""
echo "   - source the Ocean Navigator environment file"
echo "       * source tools/conf/ocean-navigator-env.sh"
echo ""
echo "   - install two packages via pip"
echo "       * pip install visvalingamwyatt"
echo ""
echo "   - change your current working directory to Ocean-Data-Map-Project/oceannavigator/frontend and compile"
echo "     the frontend codebase"
echo "       * cd /home/${STD_USER_ACCT}/Ocean-Data-Map-Project/oceannavigator/frontend"
echo "       * yarn install && yarn build"
echo ""
echo "   - now you should be able to start the Ocean Navigator web services"
echo "       * cd /home/${STD_USER_ACCT}/Ocean-Data-Map-Project"
echo "       * ./bin/launch-web-service.sh"
echo ""
