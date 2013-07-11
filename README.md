Volksbegehren „Hochschulen erhalten“
====================================

Visualisierung und Statistik zum Volksbegehren „Hochschulen erhalten“ in Brandenburg

Daten Zwischenstand 10.07.13
----------------------------

Presseinformation Nr. 05/2013 des Landeswahlleiters auf http://www.wahlen.brandenburg.de/cms/detail.php/bb1.c.335797.de.

Ergebnisse der Landkreise und kreisfreien Städte liegen in der CSV-Datei `zwischenstand.csv` in diesen Spalten:

1. `Landkreis` (meint sowohl Landkreise als auch kreisfreie Städte)
2. `Anzahl` der Eintragungen
3. `Prozent`: Abstimmungsbeteiligung in %

Die in der PI genannten fünf Gemeinden mit den meisten Eintragungen finden sich in der CSV-Datei `zwischenstand-gemeinden.csv` in diesen Spalten:

1. `Gemeinde`
2. `lon`: geogr. Länge
3. `lat`: geogr. Breite
4. `Anzahl der Eintragungen

Die Koordinaten sind von Wikipedia.  Guben habe ich etwas nach Westen gerückt; auf der Karte sieht es sonst schon wie außerhalb Brandenburg aus.


Kartendarstellung
-----------------

Im R-Skript `karte.R` werden die Daten eingelesen, aufbereitet und in drei Karten dargestellt (gespeichert als PNG):

* Anzahl Eintragungen Landkreise, mit Beschriftung
* Prozentuale Beteiligung Landkreise, mit Beschriftung
* Anzahl Eintragungen Landkreise, ohne Beschriftung; als Punkte „Top 5“-Gemeinden mit Beschriftung

Die Verwaltungsgrenzen muß man sich von http://gadm.org herunterladen: Download → Germany → R Data → Level 3.
