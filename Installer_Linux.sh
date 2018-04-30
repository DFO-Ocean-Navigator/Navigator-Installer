#!/bin/bash

# Check if we're root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root or using sudo."
  exit 1
fi

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
echo "Enter an installation directory for the Ocean Navigator: "

echo
echo "Updating package list..."
apt update

echo
echo "Installing pre-requisites..."
apt -y install git

echo
echo "Acquiring Python 3 distribution (Miniconda)..."
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

echo
echo "Installing Miniconda..."
bash Miniconda3-latest-Linux-x86_64.sh

echo
echo "Installing Python packages..."

echo
echo "Cloning Ocean Navigator..."

