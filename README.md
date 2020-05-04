## Matee-Poster: Raspberry Pi mit nginx als mobiler Netzwerk-Zugang mit Webserver.
 

Als Betriebssystem des Raspi Zero W ist die Lite-Variante von Raspbian gut geeignet: Sie   verbraucht  weniger Strom, eine graphische Oberfläche wirdnicht gestartet. Es wird noch getestet ob diese Version für den Raspi zero verwendet werden kann. 
Beschrieben wird die Installation unter Linux 
# Benötigt wird:

      ein Raspberry pi, mit SD Karte, 

# Vorkenntnisse: 

Grundkenntnisse in bash, Dateien editieren mit nano, sudo, ls, systemctl, less, cp, 

# Installation

Bitte laden Sie Raspbian Lite direkt von raspberrypi.org herunter und verwenden Sie unter Linux dd if=/home/user/aktuellesraspsian.img of=/dev/sd-- für die Installation  Damit wird sichergestellt, dass die Konfiguration im folgenden funktioniert.

 Unter windows kopieren Sie das Image mit dem Programm W32DiskImager Byte für Byte auf die Speicherkarte.  macOS-User benutzen dafür ebenfalls das Kommandozeilenprogramm dd.

 Die Einrichtung erfolgt  entweder per SSH. oder wenn die Installation auf einem Raspi 3 oder höher möglich ist direkt über Tastatur und Maus am Bildschirm. Die Vorgehensweise wird  hier  Zunächst entfernen Sie die SD-Karte aus dem Kartenleser und stecken sie nach ein paar Sekunden wieder hinein. So erzwingen Sie, dass sowohl Linux oder Windows die Partitionstabelle neu einliest –  Im folgenden wird die Installation für Linux beschrieben. User anderer Systeme müssen acht geben, dass sie nicht die Fallstricke ihrer Systeme geraten. 

Damit sich ein Raspi  in das eigene Drahtlos-Netzwerk (DraNe, oder WLAN, Wifi)  einklinken kann, benötigt er die SSID und den WLAN-Schlüssel. Diese Daten müssen in die Datei wpa_supplicant.conf eingetragen werden.

Den SSH-Daemon auf dem Raspi aktivieren wir, indem wir eine leere Datei mit dem Namen ssh im Laufwerk boot anlegen. Anschließend wird der Raspberry-Pi gestartet. Als erstes schalten wir die Stromsparfunktion für das Funk-Netzwerk aus. (Funknetzwerk == wlan0)

      sudo iw wlan0 set power_save off

So wird verhindert, dass die Stromsparfunktion des Funk-Adapters (WLAN-Adapters) bei Inaktivität abgeschaltet wird. Um dies bei zukünftigen Starts des Raspberrys vom Start an zu verhindern editieren wir die Datei

etc/network/interfaces
                        auto wlan0
                          iface wlan0 inet dhcp
                            wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
 
Oder wir verwenden die entsprechend vorkonfigurierte und auf Deutsch erklärend kommentierte
Datei  'interfaces' und passen diese für unsere Bedürfnisse an.

Als nächstes installieren wir den Webserver nginx

            sudo apt-get install nginx
 

Damit der Raspi als Funknetz-Server (WLAN Accesspoint) arbeitet, müssen wir Pakete nachinstallieren:


      sudo apt-get install hostapd dnsmasq 

Die Konfigurationsdateien beider Programme müssen nach /etc kopiert werden:


      sudo cp   /default/* /etc/default
      sudo cp -a /hostapd /etc
      sudo cp /dnsmasq.conf /etc

Jetzt benötigen wir noch einen mit statischer IP-Adresse konfigurierten WLAN-Adapter, 
Dazu öffnen wir erneut die Datei interfaces in /etc/network/interfaces  und fügen dort folgendes ein, soforn es nicht schon dort vorhanen ist:

      auto wlan0
      iface wlan0 inet static
          address 192.168.255.1
          netmask 255.255.255.0
          wireless-mode Master
          wireless-power off

Dann kopieren wir den FakeDNS-Daemon in das Verzeichnis /usr/local/bin und sorgen dafür, dass er mit systemctl beim nächsten Startvorgang automatisch startet.

      sudo cp fakedns/*.py /usr/local/bin
      sudo cp fakedns/*.service /etc/systemd/system
      sudo systemctl enable fakedns.service

Um Android- oder Apple-Geräte vom Zicken abzuhalten bearbeiten wir den ngins-Server in der Konfigurationsdatei /etc/nginx/sites-available/default und fügen vor der Zeile die mit 'locations' anfängt folgende Zeile ein:

      error_page 404 =302 http://192.168.255.1/;


Wenn der Raspi als alleiniges Gerät laufen soll empfiehlt es sich das Python-Skript 'pishutdown' zu benutzen. Um es zu installieren gehen wir wie folgt vor:
Entweder kopieren sie das Python-Skript  pyshutdown.py von /pishutdown/ nach /usr/local/bin/

oder laden das Python-Programm vom Entwickler von pishutdown.py aus dem Github-Repository herunter und speichern es im Verzeichnis /usr/local/bin

        sudo wget -O /usr/local/bin/pishutdown.py http://raw.githubusercontent.com/gilyes/pi-shutdown/master/pishutdown.py 

 Das Programm pishutdown wartet darauf, dass die GPOI-Pins 5 und 6 miteinander verbunden  werden, Das kann mit Hilfe eines Jumpers oder Steckkabels erfolgen. Wenn wir die Pins für eine Sekunde verbinden und entfernen ihn dann wieder, 
reagiert Pi-Shutdown mit einen reboot. Wird er für mehr als drei bis fünf sekunden gehalten, schalten wir den Raspi aus.

      sudo wget -O /usr/local/bin/pishutdown.py http://raw.githubusercontent.com/gilyes/pi-shutdown/master/pishutdown.py

Damit Pi-Shutdown künftig automatisch geladen wird, kopieren wir einen Systemd-Job, an die richtige Stelle und aktivieren ihn mit systemctl


      sudo cp /pishutdown/* /etc/systemd/system
      sudo systemctl enable pishutdown

# Testen und debuggen Wenn etwas nicht funktioniert

Die Installation wurde mit raspbian Stretch durchgeführt Zur Zeit wird getestet unter Buser Demnächst auch eine Bash Installationsroutine.

(demnächst mehr)



