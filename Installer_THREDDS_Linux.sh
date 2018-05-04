#!/bin/bash

# Check for network connection
# https://stackoverflow.com/a/26820300/2231969
echo -e "GET http://google.ca HTTP/1.0\n\n" | nc google.ca 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network OK."
else
    echo "Not network detected. Exiting..."
    exit 1
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
sudo useradd -r tomcat --shell /bin/false
cd /opt
if [ -d "/opt/tomcat9/" ]; then
    sudo rm -r /opt/tomcat9
fi
sudo wget http://navigator.oceansdata.ca/cdn/tomcat9-thredds.tar.gz
sudo tar -xjC /opt/ -f tomcat9-thredds.tar.gz

sudo chown -R tomcat /opt/tomcat9/
sudo chgrp -R tomcat /opt/tomcat9/

sudo mkdir /usr/local/tomcat
sudo mkdir /usr/local/tomcat/content

sudo chown -R tomcat /usr/local/tomcat
sudo chgrp -R tomcat /usr/local/tomcat

echo
echo "Starting server..."
sudo bash /opt/tomcat9/bin/startup.sh

echo
echo "Install complete! Visit localhost:8080/thredds/"
