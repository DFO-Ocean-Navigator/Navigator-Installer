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
apt -y install git software-properties-common curl libgdal1-dev
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt -y install nodejs
npm install -g bower

echo
echo "Acquiring Python 3 distribution (Miniconda)..."
wget http://navigator.oceansdata.ca/cdn/minconda-distro.tar.gz
tar -xjC /opt/tools/ -f minconda-distro.tar.gz 


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
apt -y autoremove

