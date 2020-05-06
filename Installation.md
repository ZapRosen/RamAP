# Raspberry Pi Matee-Poster Installation
Der Zugangpunkt ist auf die IP-Adresse 192.168,255.1 voreingestellt. Wenn es notwendig erscheint ändere das bitte.

## Update und Installieren von git

    sudo apt-get update && sudo apt-get upgrade && sudo apt-get install git
    sudo raspi-config
    
Konfiguriere Raspbian sofern das noch nicht geschehen ist. 

Installiere DHCPD and HOSTAPD

    sudo apt-get install dnsmasq hostapd
    
Bevor du weiter installierst stoppe dnsmasq und hostapd!

    sudo systemctl stop dnsmasq  && sudo systemctl stop hostapd

Kopiere die Konfigurationsdateien für hostapd und dnsmasq

    sudo cp default/hostapd /etc/default
    sudo cp hostapd/hostapd.conf /etc/hostapd
    sudo cp default/dnsmasq /etc/default
    sudo cp dnsmasq.conf /etc

Installiere und Konfiguriere fakedns mit der Voreinstellung auf der IP-Adresse 192.168.255.1
    
    sudo cp fakedns/fakedns.py /usr/local/bin
    sudo cp fakedns/fakedns.service /etc/systemd/system
    sudo systemctl enable fakedns.service
 
Installiere und Konfiguriere pishutdown
    
    sudo cp pishutdown/pishutdown.py /usr/local/bin
    sudo cp pishutdown/pishutdown.service /etc/systemd/system
    sudo systemctl enable pishutdown.service
 
Starte de Raspi neu
    
    sudo reboot



