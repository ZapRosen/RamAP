## nginx als Reverse-Proxy
# Motivation
Um den Matee-Poster zu erreichen muss man seine IP-Nummer in die Browserzeile eingeben.
Einfacher wäre es, wenn man nach dem Einloggen einen Namen eingeben könnte. Dies wird
erreicht, indem der Webserver nginx des Raspberry Pi als Reverse-Proxy konfiguriert wird.
# Bisherige Konfiguration des nginx
Bisher wurde der Konfiguration des nginx Webservers keine besondere Aufmerksamkeit
gewidmet. In der Datei 

      /etc/nginx/sites-available/default 

hatten wir vor 'location' diese Zeile eingefügt:

      error_page 404 =302 http://192.168.255.1/;

Damit sollte die  Fehlerseite 404 wieder auf die Startposition geleitet werden. Dieser 
Eintrag ist wichtig für Mobil-Geräte, die bei einer Fehlereingabe sonst hinausgeworfen würden.


