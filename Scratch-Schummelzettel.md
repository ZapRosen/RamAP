# Vorbereitung

* raspbian image auf sd karte brennen
* sd karte für einige Sekunden aus dem Rechner ziehen
* danach die Karte wieder in den PC stecken
* auf der root partition eine leere Datei anlegen
* Die leere Datei nach ssh umbenennen
 Dadurch wird beim booten der ssh Server gestartet.

Die Gewebe-master Datei mit root-Rechten  in die Partition rootfs /home/pi kopieren. 

 Nach dem booten einloggen mit ssh pi@<ip-nummer-des raspi>

* Stromsparfunktion wlan ausschalten

sudo iw wlan0 set power_save off

## Gewebe einrichten

* raspi konfigurieren 

     sudo raspi-config

     sudo apt-get update 
     sudo apt-get upgrade -y

* Software installieren 

     sudo apt-get install nginx hostapd dnsmasq

* Dateien kopieren 

     sudo cp default/* /etc/default/
     sudo cp hostapd/ /etc
     sudo cp -a  hostapd/ /etc
     sudo cp dnsmasq.conf /etc/

* interfaces editieren
   
sudo nano /etc/network/interfaces    Am Ende einfügen:


auto wlan0
iface wlan0 inet static
address 192.168.255.1
netmask 255.255.255.0
wireless-mode Master
wireless-power off


* fakedns einrichten

     sudo cp fakedns/*.py /usr/local/bin/
     sudo cp fakedns/*.service /etc/systemd/system
     sudo systemctl enable fakedns.service 
   
sudo nano /etc/nginx/sites-available/default # einfügen vor der Zeile location

      error_page 404 =302 http://192.168.255.1/; 

* hostapd testen, Wenn etwas nicht läuft, dann liegt es an der Fehlkonfiguration des hostapd 
 
  sudo systemctl status hostapd.service
 
* Wenn hostapd nicht läuft: debuggen mit: 

    sudo hostapd -d /etc/hostapd/hostapd.conf 
 
* Ist wlan0 geblockt? 

    sudo rfkill list wlan 

* Wenn wlan blocked :

     sudo rfkill unblock wlan

* Wenn hostapd 'masked' ist: 
   
     sudo systemctl unmask  hostapd.service

* symbolische links neu laden 

  sudo systemctl enable  hostapd.service

* hostapd neu starten 

sudo systemctl restart  hostapd.service

* und nochmal testen

     sudo systemctl status  hostapd.service
   
* Wenn hostapd läuft: 

    sudo reboot

Nach dem reboot ist die Administration über eth0 nicht mehr möglich.
Vielleicht hilft es, die interfaces Datei entsprchend zu editieren. (demnächst)


