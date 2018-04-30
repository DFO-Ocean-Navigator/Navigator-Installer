#!/bin/bash

# Check if we're root
if [ "$EUID" -ne 0 ] then
  echo "Please run as root or using sudo."
  exit 1
fi

# Check for network connection
# https://stackoverflow.com/a/26820300/2231969
echo -e "GET http://google.ca HTTP/1.0\n\n" | nc google.ca 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network OK."
else
    echo "Not network detected. Exiting..."
    exit 1
fi

# Default installation directory
install_dir = /opt/tools/

echo
echo "Enter an installation directory for the Ocean Navigator. Press [Enter] for default (/opt/tools/): "
read user_install_dir
if [$user_install_dir != ''] then
    $install_dir = $user_install_dir
fi

echo
echo "Updating package list..."
apt update

echo
echo "Installing pre-requisites..."
apt -y install git python-software-properties curl
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt -y install nodejs
npm install -g bower

echo
echo "Acquiring Python 3 distribution (Miniconda)..."
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

echo
echo "Installing Miniconda..."
bash Miniconda3-latest-Linux-x86_64.sh

echo
echo "Installing Python packages..."
conda install gdal
conda install -y -q -c conda-forge flask-compress flask-babel pykdtree geopy pyresample matplotlib
conda install -y -q -c cachetools netcdf4 basemap cmocean pint pillow shapely

echo
echo "Cloning Ocean Navigator..."
git clone https://github.com/DFO-Ocean-Navigator/Ocean-Data-Map-Project.git $install_dir
