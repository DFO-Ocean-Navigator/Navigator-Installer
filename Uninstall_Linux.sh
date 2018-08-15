#!/usr/bin/env bash

# Remove Navigator2Go installation

install_dir=/opt

# Remove Navigator code
if [ -d $install_dir/Ocean-Data-Map-Project/ ]; then
    sudo rm -r $install_dir/Ocean-Data-Map-Project/
fi

# Remove Navigator2Go app
if [ -d $install_dir/Navigator2Go/ ]; then
    sudo rm -r $install_dir/Navigator2Go/
fi

# Remove python distro
if [ -d $install_dir/tools/miniconda3/ ]; then
    sudo rm -r $install_dir/tools/miniconda3/
fi

# Remove bathymetry and topography files
if [ -d /data/hdd/misc ]; then
    sudo rm -r /data/hdd/misc/
fi

# Remove THREDDS
if [ -d /opt/tomcat9/ ]; then
    sudo rm -r /opt/tomcat9/
fi

# Remove THREDDS content
if [ -d /opt/thredds_content/ ]; then
    sudo rm -r /opt/thredds_content/
fi