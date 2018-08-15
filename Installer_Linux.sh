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

# Remove old installation
if [ -d $install_dir/Ocean-Data-Map-Project/ ]; then
    sudo rm -r $install_dir/Ocean-Data-Map-Project/
fi
if [ -d $install_dir/Navigator2Go/ ]; then
    sudo rm -r $install_dir/Navigator2Go/
fi

# Create install dirs
sudo mkdir -p $install_dir/Ocean-Data-Map-Project/
sudo mkdir -p $install_dir/Navigator2Go/

echo
echo "Updating package list..."
sudo apt update
sudo apt upgrade

echo
echo "Installing pre-requisites..."
sudo apt -y install git pigz software-properties-common curl libgdal1-dev libnetcdf-c++4-dev libnetcdf-c++4 notify-osd build-essential
sudo ldconfig
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - # Node 8
sudo apt -y install nodejs
sudo npm install -g bower

echo
echo "Grabbing Ocean Navigator..."
sudo git clone https://github.com/DFO-Ocean-Navigator/Ocean-Data-Map-Project.git $install_dir/Ocean-Data-Map-Project/
# Set permissions of git folder to be of current user
sudo chown -R ${USER:=$(/usr/bin/id -run)}:$USER $install_dir/Ocean-Data-Map-Project/
sudo chown -R ${USER:=$(/usr/bin/id -run)}:$USER $install_dir/Navigator2Go/

# Fix Bower permissions issues
sudo chown -R $USER:$(id -gn $USER) /home/$USER/.config
sudo chown -R $USER:$(id -gn $USER) /home/$USER/.npm

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
echo "Acquiring bathymetry and topography files..."
if [ ! -d /data/hdd/misc ]; then
    sudo mkdir -p /data/hdd/misc
    wget http://navigator.oceansdata.ca/cdn/bathymetry_topography.tar.gz
    pigz -dc bathymetry_topography.tar.gz | tar xf - -C /data/hdd/misc
    sudo rm bathymetry_topography.tar.gz
    sudo chown -R ${USER:=$(/usr/bin/id -run)}:$USER /data/hdd/misc
fi

echo
echo "Installing Java 10..."
sudo add-apt-repository ppa:linuxuprising/java -y
sudo apt update
sudo echo oracle-java10-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt -y install oracle-java10-installer
sudo apt -y install oracle-java10-set-default

echo
echo "Acquiring Tomcat 9 + THREDDS..."
if [ -d /opt/tomcat9/ ]; then
    sudo rm -r /opt/tomcat9
fi
wget http://navigator.oceansdata.ca/cdn/tomcat9-thredds.tar.gz
tar -xjC /home/$USER/ -f tomcat9-thredds.tar.gz
sudo mv /home/$USER/tomcat9 /opt/
sudo chown -R $USER:$USER /opt/tomcat9/
rm tomcat9-thredds.tar.gz

THREDDS_CONTENT_DIR=/opt/thredds_content
if [ ! -d $THREDDS_CONTENT_DIR ]; then
    sudo mkdir -pv $THREDDS_CONTENT_DIR
    sudo chown -R $USER:$USER $THREDDS_CONTENT_DIR
fi

sed -i "s@TDS_CONTENT@$THREDDS_CONTENT_DIR@" /opt/tomcat9/bin/setenv.sh

echo
echo "Starting server..."
bash /opt/tomcat9/bin/startup.sh
echo "To shutdown: bash /opt/tomcat9/bin/shutdown.sh"

echo
echo "THREDDS Install complete! Visit localhost:8080/thredds/"

echo
echo "Grabbing lastest version of Navigator2Go..."
curl -s https://api.github.com/repos/DFO-Ocean-Navigator/Navigator2Go/releases/latest \
| grep "browser_download_url.*tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
tar -xvzf Navigator2Go.tar.gz -C $install_dir/Navigator2Go/
rm Navigator2Go.tar.gz
chmod +x $install_dir/Navigator2Go/Navigator2Go
echo "Navigator2Go executable is found in: $install_dir/Navigator2Go/"

# Cleanup
echo
echo "Cleaning up..."
sudo apt -y autoremove

echo
echo "All done!"
