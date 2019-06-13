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
echo "Installing Java 12..."
sudo add-apt-repository ppa:linuxuprising/java -y
sudo apt update
sudo echo oracle-java10-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt -y install oracle-java12-installer
sudo apt -y install oracle-java12-set-default

echo
echo "Acquiring Tomcat 9 + THREDDS..."
#sudo useradd -r tomcat --shell /bin/false
if [ -d "/opt/tomcat9/" ]; then
    sudo rm -r /opt/tomcat9
fi
wget http://navigator.oceansdata.ca/cdn/tomcat9-thredds.tar.bz2
tar -xjC /home/$USER/ -f tomcat9-thredds.tar.bz2
rm tomcat9-thredds.tar.bz2

sudo mv /home/$USER/tomcat9 /opt/

#sudo chown -R tomcat /opt/tomcat9/
#sudo chgrp -R tomcat /opt/tomcat9/

sudo mkdir /opt/thredds_content/

sudo chown -R $USER:$USER /opt/thredds_content/

#sudo chown -R tomcat /usr/local/tomcat
#sudo chgrp -R tomcat /usr/local/tomcat

echo
echo "Starting server..."
bash /opt/tomcat9/bin/startup.sh

echo
echo "Install complete! Visit localhost:8080/thredds/"
