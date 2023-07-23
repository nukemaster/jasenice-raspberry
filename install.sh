#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

## Check if python is installed
echo -e "${GREEN}Start:${NC} Check python"
sudo apt-get install git python3 python3-pip python3-tzlocal python3-sdnotify python3-colorama python3-unidecode python3-apt python3-paho-mqtt python3-requests
if command -v python3 >/dev/null 2>&1; then
    echo -e "\tPython is already installed on this system."
else
    # Install python
    echo "\tPython is not installed on this system. Installing now..."
    sudo apt-get update
    sudo apt-get install python3
fi
echo -e "${RED}\u2713 End:${NC} Check python"

## install python modules that are required
echo -e "${GREEN}Start:${NC} Check python modules"
pip install -r requirements.txt
echo -e "${RED}\u2713 End:${NC} Check python modules"

## setup RPI reporter
echo -e "${GREEN}Start:${NC} install Rpi reporter MQTT2HA daemon"
sudo git clone https://github.com/ironsheep/RPi-Reporter-MQTT2HA-Daemon.git /opt/RPi-Reporter-MQTT2HA-Daemon

pip3 install -r /opt/RPi-Reporter-MQTT2HA-Daemon/requirements.txt

usermod daemon -a -G video

echo -e "${RED}\u2713 End:${NC} finished"

## copy files
echo -e "${GREEN}Start:${NC} Copy files"
src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install"	# copy from install direcotry
dst_dir="/"	# copy to root

# create dst_dir if it does not exist
if [ ! -d "$dst_dir" ]; then
  mkdir -p "$dst_dir"
fi

# copy all files and subdirectories from src_dir to dst_dir
for item in "$src_dir"/*; do
  if [ -d "$item" ]; then
    echo "copy r $item $dst_dir"
    # if item is a directory, recursively copy it
    cp -r "$item" "$dst_dir"
  else
    echo "copy $item $dst_dir"
    # if item is a file, copy it to dst_dir
    cp "$item" "$dst_dir"
  fi
done
echo -e "${RED}\u2713 End:${NC} File copy"


## configure services
echo -e "${GREEN}Start:${NC} Service configuration"
# enable the service
systemctl stop mqttio.service
systemctl stop DS18B20_ensure.service
systemctl stop RPiReporter.service

systemctl enable mqttio.service
systemctl enable DS18B20_ensure.service
systemctl enable RPiReporter.service

# start the service
systemctl start mqttio.service
systemctl start DS18B20_ensure.service
systemctl start RPiReporter.service

systemctl status mqttio.service
systemctl status DS18B20_ensure.service
systemctl status RPiReporter.service

systemctl daemon-reload


echo -e "${RED}\u2713 End:${NC} Service configuration"

