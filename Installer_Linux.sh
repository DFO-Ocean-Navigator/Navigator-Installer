#!/bin/bash

# Check if we're root
if [ "$EUID" -ne 0 ]; then
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

if [ -d "/opt/tools/" ]; then
echo "Test"
fi

exit 1

# Default installation directory
install_dir=/opt/tools

echo
read -p "Enter an installation directory for the Ocean Navigator. Press [Enter] for default (/opt/tools/): " user_install_dir
if [ -n "$user_install_dir" ]; then # If the variable is set...
    install_dir=$user_install_dir
fi

echo
echo "Updating package list..."
apt update

echo
echo "Installing pre-requisites..."
apt -y install git software-properties-common curl
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt -y install nodejs
npm install -g bower

echo
echo "Acquiring Python 3 distribution (Miniconda)..."
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

echo
echo "Installing Miniconda..."
if [ -d "/opt/tools/miniconda3" ]; then
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/tools/miniconda3
else
    bash Miniconda3-latest-Linux-x86_64.sh -b -u -p /opt/tools/miniconda3
fi
export PATH="/opt/tools/miniconda3/bin:$PATH"

echo
echo "Installing Python packages..."
conda install -y gdal
conda install -y -c conda-forge flask-compress flask-babel pykdtree geopy pyresample matplotlib
conda install -y -c cachetools netcdf4 basemap cmocean pint pillow shapely pykml
conda install -y lxml libiconv
conda install -y -c conda-forge thredds_crawler seawater scikit-image bottleneck xarray basemap-data-hires

echo
echo "Grabbing Ocean Navigator..."
if [ -d "$install_dir" ]; then
    git -C $install_dir/Ocean-Data-Map-Project/ pull
else
    git clone https://github.com/DFO-Ocean-Navigator/Ocean-Data-Map-Project.git $install_dir
fi

echo
echo "Building frontend files..."
npm --prefix $install_dir/Ocean-Data-Map-Project/oceannavigator/frontend/ install
npm --prefix $install_dir/Ocean-Data-Map-Project/oceannavigator/frontend/ run build

# Cleanup
echo
echo "Cleaning up..."
apt autoremove

