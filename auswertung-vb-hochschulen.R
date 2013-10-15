#### Auswertung (Karten, Plots) für die Ergebnisse des Volksbegehrens "Hochschulen erhalten"


### Ergebnisse laden

## Zwischenstand Landeswahlleiter 10.07.13 laden
eintr.zw <- read.csv("zwischenstand.csv", as.is = TRUE, fileEncoding = "latin1")

gemeinden.zw <- read.csv("zwischenstand-gemeinden.csv", as.is = TRUE, fileEncoding = "latin1")
coordinates(gemeinden.zw) <- ~ lon + lat   # Koordinatenspalten zuweisen

## vorläufiges Endergebnis
eintr.ve <- read.csv("vorlf-endergebnis.csv", as.is = TRUE, fileEncoding = "latin1")

## beides in ein dataframe
eintr.all <- merge(eintr.zw, eintr.ve, by = "Landkreis", suffixes = c(".zw", ".ve"))


### Landkreise in Deutschland von http://gadm.org/

load("DEU_adm3.RData")

## Brandenburgische Landkreise ausschneiden
brandenburg <- gadm[gadm$NAME_1 == "Brandenburg", ]
colnames(brandenburg@data)[colnames(brandenburg@data) == "NAME_3"] <- "Landkreis"

## Namen bereinigen (kreisfr. Städte; Frankfurt)
brandenburg$Landkreis <- gsub(" Städte", "", brandenburg$Landkreis)
brandenburg$Landkreis <- gsub("am Oder", "(Oder)", brandenburg$Landkreis)


### Auswertung (zusätzliche Kennzahlen)

## Prozentanteil Briefwahl an Gesamtstimmenzahl
eintr.ve$Briefprozent <- round(eintr.ve$Brief/eintr.ve$Anzahl * 100)

## Zuwachs nach Zwischenstand
eintr.all$zuwachs <- eintr.all$Anzahl.ve - eintr.all$Anzahl.zw
eintr.all$zuwachsprozent.zw <- round(eintr.all$zuwachs/eintr.all$Anzahl.zw * 100)
eintr.all$zuwachsprozent.ges <- round(eintr.all$zuwachs/eintr.all$Anzahl.ve * 100)


### Karten zeichnen

vb.file.standard.maps("zwischenstand", brandenburg, eintr.zw, gemeinden.zw,
                      "Zwischenstand 10.07.13",
                       prozent.klassen = c(0, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10))
vb.file.standard.maps("vorl-endergebnis", brandenburg, eintr.ve, NULL,
                      "Vorläufiges Endergebnis 09.10.13")

png("vorl-endergebnis-brief.png", width=480, height=480)
vb.plot.map(brandenburg, eintr.ve, zcol="Briefprozent",
            classes = c(0, seq(15, 85, by=10), 100),
            main = "prozentualer Anteil Briefwahl",
            palette.name = "RdYlGn", palette.rev = TRUE)
dev.off()

png("vorl-endergebnis-zuwachs.png", width=480, height=480)
vb.plot.map(brandenburg, eintr.all, "zuwachs",
            classes = c(0,10,20,50,100,200,500,1000,2000,5000),
            main = "Zuwachs seit Zwischenergebnis",
            palette.name = "Greens")
dev.off()

png("vorl-endergebnis-zuwachs-proz.png", width=480, height=480)
vb.plot.map(brandenburg, eintr.all, "zuwachsprozent.zw",
            classes = c(seq(30, 120, by=15), 200, 500),
            main = "proz. Zuwachs, bez. auf Zwischenergebnis",
            palette.name = "Greens")
dev.off()
