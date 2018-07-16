#!/usr/bin/env bash

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
install_dir=/opt

# Create directory if it doesn't exist
if [ ! -d "$install_dir" ]; then 
    sudo mkdir $install_dir
    sudo mkdir $install_dir/Ocean-Data-Map-Project/
    sudo mkdir $install_dir/Ocean-Navigator-Config-Tool/
fi

echo
echo "Updating package list..."
sudo apt update

echo
echo "Installing pre-requisites..."
sudo apt -y install git software-properties-common curl libgdal1-dev libnetcdf-c++4-dev libnetcdf-c++4
sudo ldconfig
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt -y install nodejs
sudo npm install -g bower

echo
echo "Grabbing Ocean Navigator..."
sudo git clone https://github.com/DFO-Ocean-Navigator/Ocean-Data-Map-Project.git $install_dir/Ocean-Data-Map-Project/
# Set permissions of git folder to be of current user
sudo chown -R ${USER:=$(/usr/bin/id -run)}:$USER $install_dir/Ocean-Data-Map-Project/
sudo chown -R ${USER:=$(/usr/bin/id -run)}:$USER $install_dir/Ocean-Navigator-Config-Tool/

echo
echo "Building frontend files..."
npm --prefix $install_dir/Ocean-Data-Map-Project/oceannavigator/frontend/ install
npm --prefix $install_dir/Ocean-Data-Map-Project/oceannavigator/frontend/ run build

echo
echo "Acquiring Python 3 distribution (Miniconda)..."
if [ ! -d $install_dir/tools/miniconda3 ]; then
    sudo mkdir -p $install_dir/tools
    wget http://navigator.oceansdata.ca/cdn/miniconda-distro.tar.gz
    sudo tar -xjC $install_dir/tools/ -f miniconda-distro.tar.gz 
    sudo rm miniconda-distro.tar.gz
fi

echo
echo "Setting PATH if needed..."
[[ ":$PATH:" != *":/opt/tools/miniconda3/bin:"* ]] && echo 'export PATH=/opt/tools/miniconda3/bin/:$PATH' >> ~/.bashrc
source ~/.bashrc

echo
echo "Grabbing lastest version of Config Tool..."
curl -s https://api.github.com/repos/DFO-Ocean-Navigator/Ocean-Navigator-Config-Tool/releases/latest \
| grep "browser_download_url.*tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
tar -xvvf Config_Tool.tar.gz $install_dir/Ocean-Navigator-Config-Tool/
rm Config_Tool.tar.gz
echo "The config tool is found in: $install_dir/Ocean-Navigator-Config-Tool/"

# Cleanup
echo
echo "Cleaning up..."
sudo apt -y autoremove
