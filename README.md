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


Daten vorläufiges Ergebnis 09.10.13
-----------------------------------

Presseinformation 17/2013 des Landeswahlleiters auf http://www.wahlen.brandenburg.de/cms/detail.php/bb1.c.343230.de.

Ergebnisse der Landkreise und kreisfreien Städte sind in der CSV-Datei `vorlf-endergebnis.csv`.  Gleiche Spalten wie beim Zwischenergebnis, zusätzlich aber noch

* `Brief`: Anzahl der „Briefwahlstimmen“ (offiziell: „per Eintragungsschein“)

Eine Liste der Gemeinden mit den meisten Eintragungen gibt es in dieser PI nicht.


Kartendarstellung
-----------------

Im R-Skript `auswertung-vb-hochschulen.R` werden die Daten eingelesen, aufbereitet und in Karten dargestellt (gespeichert als PNG):

* Zwischenergebnis, Endergebnis: Anzahl Eintragungen Landkreise, mit Beschriftung
* Zwischenergebnis, Endergebnis: Prozentuale Beteiligung Landkreise, mit Beschriftung
* nur Zwischenergebnis: Anzahl Eintragungen Landkreise, ohne Beschriftung; als Punkte „Top 5“-Gemeinden mit Beschriftung
* nur Endergebnis: Anteil Briefwahlstimmen
* Zuwachs Stimmen von Zwischen- zu Endergebnis
* prozentualer Zuwachs von Zwischen- zu Endergebnis

Die Verwaltungsgrenzen muß man sich von http://gadm.org herunterladen: Download → Germany → R Data → Level 3.
