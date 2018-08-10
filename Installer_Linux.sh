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
    sudo mkdir $install_dir/Navigator2Go/
fi

echo
echo "Updating package list..."
sudo apt update

echo
echo "Installing pre-requisites..."
sudo apt -y install git software-properties-common curl libgdal1-dev libnetcdf-c++4-dev libnetcdf-c++4 notify-osd
sudo ldconfig
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt -y install nodejs
sudo npm install -g bower

echo
echo "Grabbing Ocean Navigator..."
sudo git clone https://github.com/DFO-Ocean-Navigator/Ocean-Data-Map-Project.git $install_dir/Ocean-Data-Map-Project/
# Set permissions of git folder to be of current user
sudo chown -R ${USER:=$(/usr/bin/id -run)}:$USER $install_dir/Ocean-Data-Map-Project/
sudo chown -R ${USER:=$(/usr/bin/id -run)}:$USER $install_dir/Navigator2Go/

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

echo "Enter directory where local datasets should be stored [/opt/thredds_content/]:"
read THREDDS_CONTENT_DIR
if [ -z "${THREDDS_CONTENT_DIR// }" ]; then # Expand user input and spaces with nothing
    # Empty string given by user
    THREDDS_CONTENT_DIR=/opt/thredds_content
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
if [ -d "/opt/tomcat9/" ]; then
    sudo rm -r /opt/tomcat9
fi
wget http://navigator.oceansdata.ca/cdn/tomcat9-thredds.tar.gz
tar -xjC /home/$USER/ -f tomcat9-thredds.tar.gz
sudo mv /home/$USER/tomcat9 /opt/
sudo chown -R $USER:$USER /opt/tomcat9/
rm tomcat9-thredds.tar.gz

if [ ! -d $THREDDS_CONTENT_DIR ]; then
    sudo mkdir -pv $THREDDS_CONTENT_DIR
    sudo chown -R $USER:$USER $THREDDS_CONTENT_DIR
fi

sed -i "s@TDS_CONTENT@$THREDDS_CONTENT_DIR" /opt/tomcat9/bin/setenv.sh

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
tar -xvvf Navigator2Go.tar.gz $install_dir/Navigator2Go/
rm Navigator2Go.tar.gz
chmod +x $install_dir/Navigator2Go/Navigator2Go
echo "Navigator2Go executable is found in: $install_dir/Navigator2Go/"

# Cleanup
echo
echo "Cleaning up..."
sudo apt -y autoremove

echo
echo "All done!"
