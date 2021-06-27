#!/usr/bin/env bash

if [ ! -e bin/.configuration.updated ] ; then
   git submodule update --init --recursive
   cd tools/nvm
   git checkout -b tags/v0.38.0 v0.38.0
   cd -
   sed "s#\/home\/buildadm\/cache\/oceannavigator#$(echo $HOME)\/cache\/oceannavigator#g" -i Ocean-Data-Map-Project/oceannavigator/oceannavigator.cfg
   sed "s#LOCATION#$(echo $HOME)#g" -i tools/conf/ocean-navigator-env.sh
   touch bin/.configuration.updated
fi

if [ ! -e bin/.miniconda.installed ] ; then
   [ -d tools/miniconda ] && rm -rf tools/miniconda

   if [ $(which wget) ] ; then
      [ ! -d .tmp ] && mkdir .tmp
      printf "\n\t Downloading the latest Miniconda installation package from repo.anaconda.com\n\n"
      [ ! -e .tmp/Miniconda3-latest-Linux-x86_64.sh ] && wget --quiet -O .tmp/Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
      bash .tmp/Miniconda3-latest-Linux-x86_64.sh -b -p tools/miniconda/3/amd64
      ./tools/miniconda/3/amd64/bin/conda create --quiet --name navigator --file Ocean-Data-Map-Project/config/conda/navigator-spec-file.txt
      ./tools/miniconda/3/amd64/bin/conda create --quiet --name index-tool --file Ocean-Data-Map-Project/config/conda/index-tool-spec-file.txt
      ./tools/miniconda/3/amd64/bin/conda create --quiet --name nco-tools --file Ocean-Data-Map-Project/config/conda/nco-tools-spec-file.txt
      ./tools/miniconda/3/amd64/bin/conda create --quiet --name devops --file Ocean-Data-Map-Project/config/conda/devops-spec-file.txt
      touch bin/.miniconda.installed
   else
      printf "\n\t wget is not installed. Exiting!\n\n\n"
      exit 99
   fi
fi
