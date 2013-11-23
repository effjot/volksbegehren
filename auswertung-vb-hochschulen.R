#### Auswertung (Karten, Plots) für die Ergebnisse des Volksbegehrens "Hochschulen erhalten"


### Ergebnisse laden

## Zwischenstand Landeswahlleiter 10.07.13 laden
eintr.zw <- read.csv("zwischenstand.csv", as.is = TRUE, fileEncoding = "latin1")

gemeinden.zw <- read.csv("zwischenstand-gemeinden.csv", as.is = TRUE, fileEncoding = "latin1")
coordinates(gemeinden.zw) <- ~ lon + lat   # Koordinatenspalten zuweisen

## vorläufiges Endergebnis
eintr.ve <- read.csv("vorlf-endergebnis.csv", as.is = TRUE, fileEncoding = "latin1")

## endgültiges Ergebnis
eintr.end <- read.csv("endergebnis.csv", as.is = TRUE, fileEncoding = "latin1")

## alles in ein dataframe
eintr.all <- merge(eintr.zw, eintr.ve, by = "Landkreis", suffixes = c(".zw", ".ve"),
                   sort = TRUE)
eintr.all <- merge(eintr.all, eintr.end, by = "Landkreis", suffixes = c("", ".end"),
                   sort = TRUE)
names(eintr.all)[names(eintr.all) == "Anzahl"] <- "Anzahl.end"
names(eintr.all)[names(eintr.all) == "Prozent"] <- "Prozent.end"

## Nachtflugverbot
nachtflug <- read.csv("nachtflugverbot.csv", as.is = TRUE, fileEncoding = "latin1")
nachtflug <- nachtflug[order(nachtflug$Landkreis), ]


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
eintr.end$Briefprozent <- round(eintr.end$Brief/eintr.end$Anzahl * 100)

## Zuwachs nach Zwischenstand
eintr.all$zuwachs <- eintr.all$Anzahl.end - eintr.all$Anzahl.zw
eintr.all$zuwachsprozent.zw <- round(eintr.all$zuwachs/eintr.all$Anzahl.zw * 100)
eintr.all$zuwachsprozent.ges <- round(eintr.all$zuwachs/eintr.all$Anzahl.end * 100)

## Unterschied Nachtflugverbot, Hochschulen erhalten
eintr.all$d.nachtflug.prozpkt <- eintr.all$Prozent.end - nachtflug$Prozent


### Karten zeichnen

vb.file.standard.maps("zwischenstand", brandenburg, eintr.zw, gemeinden.zw,
                      "Zwischenstand 10.07.13",
                       prozent.klassen = c(0, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10))
vb.file.standard.maps("vorl-endergebnis", brandenburg, eintr.ve, NULL,
                      "Vorläufiges Endergebnis 09.10.13")
vb.file.standard.maps("endergebnis", brandenburg, eintr.end, NULL,
                      "Endergebnis 24.10.13")

png("vorl-endergebnis-brief.png", width=480, height=480)
vb.plot.map(brandenburg, eintr.ve, zcol="Briefprozent",
            classes = c(0, seq(15, 85, by=10), 100),
            main = "prozentualer Anteil Briefwahl",
            palette.name = "PuOr",
            palette.rev = FALSE)
dev.off()

png("endergebnis-brief.png", width=480, height=480)
vb.plot.map(brandenburg, eintr.end, zcol="Briefprozent",
            classes = c(0, seq(15, 85, by=10), 100),
            main = "prozentualer Anteil Briefwahl",
            palette.name = "PuOr",
            palette.rev = FALSE)
dev.off()

png("endergebnis-zuwachs.png", width=480, height=480)
vb.plot.map(brandenburg, eintr.all, "zuwachs",
            classes = c(0,10,20,50,100,200,500,1000,2000,5000),
            main = "Zuwachs seit Zwischenergebnis",
            palette.name = "Greens")
dev.off()

png("endergebnis-zuwachs-proz.png", width=480, height=480)
vb.plot.map(brandenburg, eintr.all, "zuwachsprozent.zw",
            classes = c(seq(30, 120, by=15), 200, 500),
            main = "proz. Zuwachs, bez. auf Zwischenergebnis",
            palette.name = "Greens")
dev.off()


png("vergleich-nachtflug-proz-1.png")
vb.plot.map(brandenburg, eintr.end, "Prozent",
            classes = c(0, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20),
            main = "proz. Ergebnis Hochschulen erhalten")
dev.off()

png("vergleich-nachtflug-proz-2.png")
vb.plot.map(brandenburg, nachtflug, "Prozent",
            classes = c(0, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20),
            main = "proz. Ergebnis Nachtflugverbot")
dev.off()

png("vergleich-nachtflug-prozpkt.png")
vb.plot.map(brandenburg, eintr.all, "d.nachtflug.prozpkt",
            classes = c(-20, -10, -5, -2, -1, 1, 2, 5, 10, 20),
            main = "Prozentpunkte Unterschied Hochschulen – Nachtflug",
            palette.name = "RdYlGn")
dev.off()
