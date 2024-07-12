#!/bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "Du solltest Root-Rechte haben, wenn du dieses Skript ausführst."

#Systemupdate

echo Energiesparfunktion zur Installation ausschalten
sudo iw wlan0 set power_save off
echo Systemupdate
sudo apt-get update -y
echo "*******  update abgeschlossen  *********************"

#
echo "Installiere Software"
echo "*****************************"
echo " hole nginx" 
sudo apt-get install nginx -y

echo "hole hostapd, ..............."
sudo apt-get install hostapd -y

echo "hole dnsmasq ................."
sudo apt install dnsmasq -y
#
#kopieren Konfigurationsdateien
#
echo "Kopiere Konfigurations-Dateien ..........." 

sudo cp default/* /etc/default
sudo cp -a hostapd /etc
sudo cp dnsmasq.conf /etc

sudo cp network/interfaces /etc/network/interfaces

sudo cp fakedns/*.py /usr/local/bin
sudo cp fakedns/*.service /etc/systemd/system
sudo systemctl enable fakedns.service

#
#hole pi-shutdown

#sudo wget -O /usr/local/bin/pishutdown.py http://raw.githubusercontent.com/gilyes/pi-shutdown/master/pishutdown.py

#sudo cp pishutdown/* /etc/systemd/system
#sudo systemctl enable pishutdown

echo "starte hostapd"
echo " ********* unmask hostapd **************"
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
echo " lade hostapd  und starte neu "
sudo systemctl restart hostapd

echo "***********************************************************************"
echo "   Starte den Raspberry pi mit sudo reboot    +++++++++++++++++++++++++"
echo "========================================================================"














