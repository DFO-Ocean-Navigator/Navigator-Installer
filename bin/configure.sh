#!/usr/bin/env bash

if [ ! -e bin/.configuration.updated ] ; then
   sed "s#\/home\/buildadm\/cache\/oceannavigator#$HOME\/cache\/oceannavigator#g" -i ../Ocean-Data-Map-Project/oceannavigator/oceannavigator.cfg
   sed "s#LOCATION#$HOME#g" -i ../tools/conf/ocean-navigator-env.sh
   touch .configuration.updated
fi

cd tools/nvm
git checkout tags/v0.36.0 -b v0.36.0
