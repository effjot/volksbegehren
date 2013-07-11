library(sp)
library(RColorBrewer)


### Zwischenstand Landeswahlleiter 10.07.13 laden
eintr <- read.csv("zwischenstand.csv", as.is = TRUE, fileEncoding = "latin1")

gemeinden <- read.csv("zwischenstand-gemeinden.csv", as.is = TRUE, fileEncoding = "latin1")
coordinates(gemeinden) <- ~ lon + lat   # Koordinatenspalten zuweisen


### Landkreise in Deutschland von http://gadm.org/
load("DEU_adm3.RData")

## Brandenburgische Landkreise ausschneiden
brandenburg <- gadm[gadm$NAME_1 == "Brandenburg", ]
colnames(brandenburg@data)[colnames(brandenburg@data) == "NAME_3"] <- "Landkreis"

## Namen bereinigen (kreisfr. Städte; Frankfurt)
brandenburg$Landkreis <- gsub(" Städte", "", brandenburg$Landkreis)
brandenburg$Landkreis <- gsub("am Oder", "(Oder)", brandenburg$Landkreis)


### VB-Ergebnisse mit Karte verbinden

karte <- brandenburg
karte@data <- data.frame(brandenburg@data,
                         eintr[match(brandenburg@data[, "Landkreis"],
                                     eintr[, "Landkreis"]), ])


### Kartenerstellung

## Klasseneinteilung

anzahl.klassen <- c(0, 50, 100, 200, 500, 1000, 2000, 5000, 10000)
prozent.klassen <- c(0, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10)

karte$anz.klassif <- cut(karte$Anzahl, anzahl.klassen,
                          labels = paste("bis", tail(anzahl.klassen, -1)))
karte$proz.klassif <- cut(karte$Prozent, prozent.klassen,
                          labels = paste0("bis ", tail(prozent.klassen, -1), "%"))

## Darstellung

anz.palette <- brewer.pal(nlevels(karte$anz.klassif), "GnBu")
proz.palette <- brewer.pal(nlevels(karte$proz.klassif), "GnBu")

karte.ohne.spn <- karte[karte$Landkreis != "Spree-Neiße", ]
karte.nur.spn <- karte[karte$Landkreis == "Spree-Neiße", ]
coord.ohne.spn <- coordinates(karte.ohne.spn)
coord.nur.spn <- coordinates(karte.nur.spn)
coord.nur.spn[2] <- coord.nur.spn[2] - 0.12
gemnd.ohne.cb <- gemeinden[gemeinden$Gemeinde != "Cottbus", ]
gemnd.nur.cb <- gemeinden[gemeinden$Gemeinde == "Cottbus", ]

png("zwischenstand-anz.png", width=480, height=480)
spplot(karte, "anz.klassif", col.regions = anz.palette, col = grey(0.75),
       main = "Zwischenstand 10.07.13: Anzahl Eintragungen",
       sp.layout = list(
         list("sp.text", coord.nur.spn, karte.nur.spn$Anzahl),
         list("sp.text", coord.ohne.spn, karte.ohne.spn$Anzahl)))
dev.off()

png("zwischenstand-proz.png", width=480, height=480)
spplot(karte, "proz.klassif", col.regions = proz.palette, col = grey(0.75),
       main = "Zwischenstand 10.07.13: Abstimmungsbeteiligung in Prozent",
       sp.layout = list(
         list("sp.text", coord.nur.spn, karte.nur.spn$Prozent),
         list("sp.text", coord.ohne.spn, karte.ohne.spn$Prozent)))
dev.off()

png("zwischenstand-top5.png", width=480, height=480)
spplot(karte, "anz.klassif", col.regions = anz.palette, col = grey(0.75),
       main = "Zwischenstand 10.07.13: Top-5-Gemeinden",
       sp.layout = list(
         list("sp.points", gemeinden, pch = 16, col = "red", cex = 1.5),
         list("sp.text", coordinates(gemnd.ohne.cb), gemnd.ohne.cb$Anzahl, adj = c(1.2, 1.2), cex = 1.5),
         list("sp.text", coordinates(gemnd.nur.cb), gemnd.nur.cb$Anzahl, pos = 4, cex = 1.5)))
dev.off()


### Entfernungsabhängigkeit

## Entfernungen (km) von Cottbus berechnen

coord.cb <- coordinates(karte[karte$Landkreis == "Cottbus", ])

dists <- spDistsN1(coordinates(karte), coord.cb, longlat = TRUE)
entf <- data.frame(d = dists, proz = karte$Prozent,
                   d.klassif = cut(dists,
                     c(0,50, 100, 150, 250), include.lowest = TRUE))
rm(dists)

## Plots

# Prozent vs. Entferung, y logarithmisch
plot(entf$d, entf$proz, log = "y")

# Prozent vs. Entferung, Ausschnitt
plot(entf$d, entf$proz, ylim = c(0, 1))

# Prozent vs. Entferung, Ausschnitt, x logarithmisch
plot(entf$d, entf$proz, ylim = c(0, 1), log = "x")

# Boxplot, y logarithmisch
plot(entf$d.klass, entf$proz, log = "y",
     xlab = "Entfernung von Cottbus (km)",
     ylab = "Prozentuale Beteiligung, logarithm.",
     boxwex = 0.25, col= "cornsilk")
points(1:4, aggregate(entf$proz, list(entf$d.klass), FUN = mean)$x)
text(1:4, c(0.2, 0.07, 0.3, 0.12), paste("N =", aggregate(entf$proz,by= list(entf$d.klassif), FUN = length)$x))
