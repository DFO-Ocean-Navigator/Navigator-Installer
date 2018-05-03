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

echo javac -version

echo
echo "Installing Tomcat 9..."
# https://askubuntu.com/questions/777342/how-to-install-tomcat-9
# https://www.rosehosting.com/blog/install-tomcat-9-on-an-ubuntu-16-04-vps/
sudo useradd -r tomcat --shell /bin/false
cd /opt
sudo wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.7/bin/apache-tomcat-9.0.7.tar.gz
sudo tar -xzf apache-tomcat-9.0.7.tar.gz
sudo mv apache-tomcat-9.0.7 tomcat9
sudo chown -hR tomcat: tomcat9

echo
echo "Installing THREDDS..."
sudo wget ftp://ftp.unidata.ucar.edu/pub/thredds/4.6/current/thredds.war -P /opt/tomcat9/webapps/

echo
echo "Installing Tomcat service..."
sudo echo "[Unit]
Description=Tomcat9
After=network.target

[Service]
Type=forking
User=tomcat9
Group=tomcat9

Environment=CATALINA_PID=/opt/tomcat9/tomcat9.pid
Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
Environment=CATALINA_HOME=/opt/tomcat9
Environment=CATALINA_BASE=/opt/tomcat9
Environment="CATALINA_OPTS=-Xms4096m -Xmx4096m"
Environment="JAVA_OPTS=-Dfile.encoding=UTF-8 -Dnet.sf.ehcache.skipUpdateCheck=true -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC"

ExecStart=/opt/tomcat9/bin/startup.sh
ExecStop=/opt/tomcat9/bin/shutdown.sh

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat.service

echo
echo "Configuring Environment Variables..."

user=$(whoami)
sudo su root
echo "export CATALINA_HOME="/opt/tomcat9"" >> /etc/environment
echo "export JAVA_HOME="/usr/lib/jvm/java-10-oracle"" >> /etc/environment
echo "export JRE_HOME="/usr/lib/jvm/java-10-oracle/jre"" >> /etc/environment
source /etc/environment
source ~/.bashrc

systemctl daemon-reload
systelctl start tomcat
systemctl enable tomcat

su $user