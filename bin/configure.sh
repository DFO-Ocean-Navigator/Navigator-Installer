#!/usr/bin/env bash

if [ ! -e bin/.configuration.updated ] ; then
   git submodule update --init --recursive
   cd tools/nvm
   git checkout -b tags/v0.36.0 v0.36.0
   cd -
   sed "s#\/home\/buildadm\/cache\/oceannavigator#$(echo $HOME)\/cache\/oceannavigator#g" -i Ocean-Data-Map-Project/oceannavigator/oceannavigator.cfg
   sed "s#LOCATION#$(echo $HOME)#g" -i tools/conf/ocean-navigator-env.sh
   touch bin/.configuration.updated
fi

if [ ! -e bin/.miniconda.installed ] ; then
   rm -rf tools/miniconda
   bash Miniconda3-latest-Linux-x86_64.sh -b -p tools/miniconda/3/amd64
   ./tools/miniconda/3/amd64/bin/conda create --name navigator --file Ocean-Data-Map-Project/config/conda/navigator-spec-file.txt
   ./tools/miniconda/3/amd64/bin/conda create --name index-tool --file Ocean-Data-Map-Project/config/conda/index-tool-spec-file.txt
   ./tools/miniconda/3/amd64/bin/conda create --name nco-tools --file Ocean-Data-Map-Project/config/conda/nco-tools-spec-file.txt
   ./tools/miniconda/3/amd64/bin/conda create --name devops --file Ocean-Data-Map-Project/config/conda/devops-spec-file.txt
   touch bin/.miniconda.installed
fi

