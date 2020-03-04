# Steps for deployment
* groupadd -g 1001 buildadm
* useradd -u 1001 -g 1001 -m -s /bin/bash buildadm
* cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git buildadm
