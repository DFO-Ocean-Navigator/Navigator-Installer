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
sudo rm apache-tomcat-9.0.7.tar.gz
sudo mv apache-tomcat-9.0.7 tomcat9
sudo chown -hR tomcat: tomcat9

echo
echo "Installing THREDDS..."
sudo wget ftp://ftp.unidata.ucar.edu/pub/thredds/4.6/current/thredds.war -P /opt/tomcat9/webapps/
sudo chown tomcat /opt/tomcat9/webapps/thredds.war

echo "#!/bin/sh

#
# ENVARS for Tomcat
#
export CATALINA_HOME="/opt/tomcat9"
export CATALINA_BASE="/opt/tomcat9"
export JAVA_HOME="/usr/lib/jvm/java-10-oracle"
export JRE_HOME="/usr/lib/jvm/java-10-oracle/bin"


# TDS specific ENVARS
#
# Define where the TDS content directory will live
#   THIS IS CRITICAL and there is NO DEFAULT - the
#   TDS will not start without this.
#
CONTENT_ROOT=-Dtds.content.root.path=/opt/thredds/

# set java prefs related variables (used by the wms service, for example)
JAVA_PREFS_ROOTS="-Djava.util.prefs.systemRoot=$CATALINA_HOME/content/thredds/javaUtilPrefs \
                  -Djava.util.prefs.userRoot=$CATALINA_HOME/content/thredds/javaUtilPrefs"

#
# Some commonly used JAVA_OPTS settings:
#
NORMAL="-d64 -Xmx4096m -Xms512m -server -ea"
HEAP_DUMP="-XX:+HeapDumpOnOutOfMemoryError"
HEADLESS="-Djava.awt.headless=true"

#
# Standard setup.
#
JAVA_OPTS="$CONTENT_ROOT $NORMAL $MAX_PERM_GEN $HEAP_DUMP $HEADLESS $JAVA_PREFS_ROOTS"

export JAVA_OPTS" > /opt/tomcat9/bin/setenv.sh

echo "Setup complete! To start Tomcat + THREDDS: bash /opt/tomcat9/bin/startup.sh"
