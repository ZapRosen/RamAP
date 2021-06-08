# Gewebe Raspberry Pi  als mobiler Access-Point mit nginx Webserver.

## Warum Gewebe?

Irgendeinen Namen sollte das Bastelprojekt haben. RamAP: Raspberry mobiler Access-Point hieß es mal oder Matee-Poster. Alle Namen sind mir noch nicht zufriedenstellend. Gewebe steht hier für ein Netzwerk. Ein Gewebe vom Raspberry-Pi der die Nutzer zu einem Gewebe vereinigt. (?)   Dieses Bastelprojekt wurde gecovert vom c't Flugblatt. Mein Dank geht an den Autor des Artikels in der c't von 2017 https://www.heise.de/select/ct/2017/22/1508780300482172 

Die Intention dieses Bastelprojekts ist jedoch anderer Art und keinesfalls subversiv motiviert. Im Grunde ist dieses ein Captive-Portal, das die Nutzergeräte einfängt und mit Information versorgt. 

### Eine Kurzanleitung 

Eine kurze Anleitung zur  Installation findest Du in der Datei Scratch-Schummelzettel.md . Kopiere und postiere die entsprechenden bash-Befehle oder Einträge in Konfigurationsdateien. Ein Installationsskript ist derzeit nicht geplant. 
Das Radio-Modul ist nach dem ersten booten ausgeschaltet. Nach der Installation muss es mit rfkill entsperrt werden und der hostapd muss neu geladen und gestartet werden. Sonst läuft es nicht.

### Raspbian lite

Als Betriebssystem für den Raspberry-pi verwenden wir Raspian lite.  Es verbraucht nur wenig Strom. Eine graphische Oberfläche ist nicht vorgesehen. Entsprechend sind die Einstellungen nach dem ersten booten mit sudo raspi-config vorzunehmen. Es wird noch getestet ob diese Version für den Raspi zero verwendet werden kann. 
Beschrieben wird die Installation unter Linux 

### Benötigt wird:

      ein Raspberry pi, mit SD-Karte, Jumperkabel Tastschalter, Stromversorgung durch ein Netzteil 

### Vorkenntnisse: 

Grundkenntnisse in: 
  
 * Dateien editieren mit nano, 
 * bash-Befehle: sudo, ls, systemctl, less, cp, lsblk, rfkill
 * Einrichtung und Inbetriebnahme des Raspberry-pi
  
## Installation

Raspbian Lite direkt von raspberrypi.org herunterladen  und  unter Linux mit dd if=/home/user/aktuellesraspsian.img of=/dev/sd-- auf die SD-Karte übertragen. Mit lsblk wird geprüft welche Laufwerksbezeichnungen vorhanden sind. Diese müssen bei der Installation berücksichtigt werden.

Unter windows kopierst du das Image mit dem Programm W32DiskImager Byte für Byte auf die Speicherkarte.  macOS-User benutzen dafür wie die Linuxer das Kommandozeilenprogramm dd. Das Programm 'etcher' eignet sich ebenfalls zum Brennen der SD-Karte.
https://www.balena.io/etcher/ 

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
 

Damit der Raspi als Funknetz-Server (WLAN-Accesspoint) arbeitet, müssen wir Pakete nachinstallieren:


      sudo apt-get install hostapd dnsmasq 

Gleich im Anschluss daran schalten wir die Programme aus.

      sudo systemctl stop dnsmasq   
      sudo systemctl stop hostapd


Die Konfigurationsdateien beider Programme müssen nach /etc kopiert werden:


      sudo cp   /default/* /etc/default
      sudo cp -a /hostapd /etc
      sudo cp /dnsmasq.conf /etc

Jetzt benötigen wir noch einen mit statischer IP-Adresse konfigurierten WLAN-Adapter, 
Dazu öffnen wir erneut die Datei interfaces in /etc/network/interfaces  und fügen dort folgendes ein, sofern es nicht schon dort vorhanden ist:

      auto wlan0
      iface wlan0 inet static
          address 192.168.255.1
          netmask 255.255.255.0
          wireless-mode Master
          wireless-power off

Solltest Du bis dahin den raspi über ethernet und den Router eingerichtet haben, denk daran, dass nach einem Neustart des raspberrys dieser nicht mehr über das Drahtnetzwerk erreichbar ist. Möchtest Du den raspi weiterhin über LAN administrieren, sind weitere Einträge notwendig.

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

## Testen und debuggen Wenn etwas nicht funktioniert

Die Installation wurde mit raspbian Buster durchgeführt. Wenn etwas nicht funktioniert, liegt es meistens am Programm 'hostapd' oder daran, dass sich in einer Datei ein Tippfehler befindet. Nach der Installation sollte man hostapd sofort stoppen mit 

      sudo systemctl stop hostapd
  
Danach kann man das Programm neu laden und starten.

      sudo systemctl enable hostapd.service
      sudo systemctl restart hostapd.service


## Fazit
Es gibt zahlreiche Möglichkeiten, das Gewebe weiterzuentwickeln. Man könnte in 'interfaces' noch eine bridge und einen eth Zugang legen. An einen Router angeschlossen könnte Gewebe als Gäste-Netzwerk dienen. Dieses Projekt ist unter Bildungsaspekten und für Bildungszwecke gedacht. Man könnte darauf moodle installieren und den Raspi als lokales Bildungsprojekt benutzen.

Es ist auf keinen Fall für industrielle oder öffentliche Aufgaben gedacht. Obwohl dieses auch möglich wäre. Es wird keine Gewähr übernommen für Schäden. 

Die Rechte der hier verwendeten Programme, Dateien und Installationen liegen bei den entsprchenden Besitzern. Mein Dank geht an Daniel Cooper für den Artikel "In die Freiheit entlassen" https://www.heise.de/select/ct/2017/22/1508780300482172 
Der Artikel hat mir zahlreiche Stunden an lustvoller Frickelarbeit ^^ beschert. Bei der Fehlersuche habe ich viel über Linux im allgemeinen und hostapd im besonderen gelernt.
 



