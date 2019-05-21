# Raspi mit einem python-Skript ausschalten
Um den Raspi sicher wieder herunterzufahren gibt es
pishutdown.py, ein Python-Skript, dass ich hier auf dieser
Seite geforkt habe.

pi-shutdown
===========

dient zum herunterfahren oder rebooten des Raspberry Pi mit Hilfe 
eines Druckknopfs oder einer Steckbrücke. 

## Anwendung:
Verbinde die Gpio Pins 5 und 6 des Raspberry Danach fährt der 
Raspberry herunter oder startet neu. Wenn der Knopf länger als 
3 Sekunden gedrückt wird fährt er herunter, Wenn kürzer als 3 Sekunden 
gedrückt wird, bootet der Raspi neu.
