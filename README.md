## Steps to use when deploying the Ocean Navigator application on a Ubuntu, Debian, CentOS, Fedora, and /or Red Hat operating systems.

### For those who wish to run a Red Hat based operating system the libnsl library is *required* by Miniconda to be able to run its various binaries and libraries.

```bash
dnf install libnsl -y
```

### Create standard Linux account. Adjust the variable STD_USER_ACCT accordingly.

```bash
STD_USER_ACCT="buildadm"
groupadd -g 1001 ${STD_USER_ACCT}
useradd -u 1001 -g 1001 --no-create-home -s /bin/bash ${STD_USER_ACCT}
```

### (OPTIONAL) If you are wishing to use our Datastore. Please create the /data directory and ensure that the user is set as owner in order for the ${HOME}/bin/mount-remote.sh script to work as stated later in this installation recipe. 

```bash
mkdir /data && chown ${STD_USER_ACCT}:${STD_USER_ACCT} /data
```

### Change your present working directory to /home and clone the Navigator-Install.git repository.

```bash
cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git ${STD_USER_ACCT}
```

### Change user and group ownership of the /home/${STD_USER_ACCT} to the ${STD_USER_ACCT} account and become the ${STD_USER_ACCT} user.

```bash
chown -R ${STD_USER_ACCT}:${STD_USER_ACCT} /home/${STD_USER_ACCT}/ ; su - ${STD_USER_ACCT}
```

### Change your present working directory to /home and clone the Navigator-Install.git repository.

```bash
cd /home ; git clone https://github.com/DFO-Ocean-Navigator/Navigator-Installer.git ${STD_USER_ACCT}
```

### Change user and group ownership of the /home/${STD_USER_ACCT} to the ${STD_USER_ACCT} account and become the ${STD_USER_ACCT} user.

```bash
chown -R ${STD_USER_ACCT}:${STD_USER_ACCT} /home/${STD_USER_ACCT}/ 
su - ${STD_USER_ACCT}
```

### Run the bin/configure.sh script in order to populate the toolchain and checkout various repos both internally and externally

```bash 
bash bin/configure.sh
```

### Source the Ocean Navigator environment file located in tools/conf/ocean-navigator-env.sh in order to have your session's environment variables update.

```bash 
source tools/conf/ocean-navigator-env.sh
```

### pip install a package which is not available in the various conda repos at this time.

```bash 
pip install visvalingamwyatt
```

### Install Node version 12.22.1, use npm to bring in yarn and bower.

```bash
nvm install v12.22.1 
npm install -g yarn 
npm install -g bower
```

### Change your working directory to Ocean-Data-Map-Project/oceannavigator/frontend, and build the UI

```bash
cd ${HOME}/Ocean-Data-Map-Project/oceannavigator/frontend 
yarn install
yarn build
```

### (OPTIONAL) If you are using our Datastore please send your request to DFO.OceanNavigator-NavigateurOcean.MPO@dfo-mpo.gc.ca and attach a copy of the Public SSH key generated for the user hosting the Ocean Navigator software.

```bash
${HOME}/bin/mount-remote.sh
```

### (OPTIONAL) If you wish to visualize your local datasets. You will need to update the datasetconfig.json and oceannavigator.cfg configuration files.

```bash
cd ${HOME}/Ocean-Data-Map-Project/oceannavigator/configs
``` 
- edit datasetconfig.json
- edit oceannavigator.cfg

### Change back to the Ocean-Data-Map-Project directory and launch the Gunicorn web services.

```bash
cd ${HOME}/Ocean-Data-Map-Project && ./launch-web-service.sh
```

### Alternate Linux operating systems we have been able to successfully install and run the Ocean Navigator software on;

- [Arch Linux](https://archlinux.org/)
- [CentOS](https://www.centos.org/) 7 & 8
- [Debian](https://www.debian.org/) 9, 10 & newer 
- [Fedora](https://getfedora.org/) 33 & newer
- [Red Hat](https://www.redhat.com/en) (7 & 8)
- [openSUSE](https://www.opensuse.org/) both Leap 15.3 & Tumbleweed
- [Rocky Linux](https://rockylinux.org/) 8.4 (Green Obsidian)
- [Ubuntu](https://ubuntu.com/) 18.04 LTS & newer
