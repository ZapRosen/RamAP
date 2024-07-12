## Wenn etwas nicht läuft
Wenn nach dem Starten des media2x der Access-Point nicht im Gastrechner auftaucht liegt es 
höchstwahrscheinlich daran, dass hostapd nicht gestartet ist. Das Programm ist dafür zuständig den
Zugangspunkt (denglisch: Access-point) zu starten.

Versuche:

sudo rfkill list
sudo rfkill list wlan
sudo rfkill unblock wifi

sudo systemctl status hostapd.service
  - wenn hostapd dead oder masked ist:
  - sudo systemctl unmask hostapd
  - sudo systemctl enable hostapd

sudo systemctl restart hostapd.service

oder debug dateien ansehen und google fragen 
sudo hostapd -d /etc/hostapd/hostapd.conf > debug.txt
less debug.txt


