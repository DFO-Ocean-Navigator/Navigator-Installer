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

