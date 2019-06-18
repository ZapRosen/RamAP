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

# Konfiguration als Reverse-Proxy

 Die nginx Hauptkonfigurationsdatei findet man unter /etc/nginx/conf.d/
In meinen Fall findet man dort den Verweis auf zwei weitere Verzeichnisse: /etc/nginx/conf.d/ und /etc/nginx/sites-enabled/
In der Datei nginx.conf ist dies bei mir dieser entsprechende Abschnitt:

 \##
        \# Virtual Host Configs
        
        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
Im Verzeichnis /etc/nginx/conf.d/ werden alle Dateien mit der Endung .conf mit eingelesen. Dies wurde durch das /*.conf; am Ende der include Anweisung festgelegt. Soll eine dort liegende Konfigurationsdatei nicht ausgeführt werden, so muss die Dateiendung geändert werden, z.B. auf .disabled.
Im Verzeichnis /etc/nginx/sites-enabled/ werden alle dort liegenden Dateien berücksichtigt, festgelegt durch das /*; am Ende der entsprechenden includeAnweisung. Soll eine Datei dort nicht ausgeführt werden, muss diese aus dem Verzeichnis entfernt werden, z.B. durch verschieben in den Ordner /etc/nginx/sites-available.
#



server {
  listen 80;
  listen [::]:80;

  server_name herwig.de;

  location / {
      proxy_pass http://192.168.1.100/;
  }
}

location / {
      proxy_pass http://192.168.1.100/;

 schaltet den Buffer des Proxys für die Verbindung aus,
 z.B. für node.js Applicationen mit Realtime Interaktionen
      proxy_buffering off;

 sendet die IP-Adresse des Clients zum Host

      proxy_set_header X-Real-IP $remote_addr;
      }


