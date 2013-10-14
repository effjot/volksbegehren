#### Auswertung (Karten, Plots) für die Ergebnisse des Volksbegehrens "Hochschulen erhalten"


### Ergebnisse laden

## Zwischenstand Landeswahlleiter 10.07.13 laden
eintr.zw <- read.csv("zwischenstand.csv", as.is = TRUE, fileEncoding = "latin1")

gemeinden.zw <- read.csv("zwischenstand-gemeinden.csv", as.is = TRUE, fileEncoding = "latin1")
coordinates(gemeinden.zw) <- ~ lon + lat   # Koordinatenspalten zuweisen

## vorläufiges Endergebnis
eintr.ve <- read.csv("vorlf-endergebnis.csv", as.is = TRUE, fileEncoding = "latin1")


### Landkreise in Deutschland von http://gadm.org/

load("DEU_adm3.RData")

## Brandenburgische Landkreise ausschneiden
brandenburg <- gadm[gadm$NAME_1 == "Brandenburg", ]
colnames(brandenburg@data)[colnames(brandenburg@data) == "NAME_3"] <- "Landkreis"

## Namen bereinigen (kreisfr. Städte; Frankfurt)
brandenburg$Landkreis <- gsub(" Städte", "", brandenburg$Landkreis)
brandenburg$Landkreis <- gsub("am Oder", "(Oder)", brandenburg$Landkreis)


### Karten erzeugen

vb.file.standard.maps("zwischenstand", brandenburg, eintr.zw, gemeinden.zw,
                      "Zwischenstand 10.07.13",
                       prozent.klassen = c(0, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10))
vb.file.standard.maps("vorl-endergebnis", brandenburg, eintr.ve, NULL,
                      "Vorläufiges Endergebnis 10.09.13")
