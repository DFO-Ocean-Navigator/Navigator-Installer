# Steps for deployment

## Create standard Linux account.

* groupadd -g 1001 buildadm
* useradd -u 1001 -g 1001 --no-create-home -s /bin/bash buildadm

## Change your present working directory to /home and clone the Navigator-Install.git.

* cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git buildadm

## Become the buildadm user, change your working directory to Ocean-Data-Map-Project, and launch the web services.
* su - buildadm ; cd Ocean-Data-Map-Project ; ./launch-web-service.sh
