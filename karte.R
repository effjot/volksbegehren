library(sp)
library(RColorBrewer)


### Zwischenstand Landeswahlleiter 10.07.13 laden
eintr <- read.csv("zwischenstand.csv", as.is = TRUE)


### Landkreise in Deutschland von http://gadm.org/
load("DEU_adm3.RData")

## Brandenburgische Landkreise ausschneiden
karte <- gadm[gadm$NAME_1 == "Brandenburg", ]

## Namen bereinigen (kreisfr. Städte; Frankfurt)
karte$NAME_3 <- gsub(" Städte", "", karte$NAME_3)
karte$NAME_3 <- gsub("am Oder", "(Oder)", karte$NAME_3)


### VB-Ergebnisse mit Karte verbinden
### (übernommen von http://casoilresource.lawr.ucdavis.edu/drupal/book/export/html/664)

# 'join' the new data with merge()
# all.x=TRUE is used to ensure we have the same number of rows after the join
# in case that the new table has fewer
merged <- merge(x = karte@data, y = eintr,
                by.x = "NAME_3", by.y = "Landkreis",
                all.x = TRUE)

# generate a vector that represents the original ordering of rows in the sp object
correct.ordering <- match(karte@data$NAME_3, merged$NAME_3)

# overwrite the original dataframe with the new merged dataframe, in the correct order
karte@data <- merged[correct.ordering, ]


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

karte.ohne.spn <- karte[karte$NAME_3 != "Spree-Neiße", ]
karte.nur.spn <- karte[karte$NAME_3 == "Spree-Neiße", ]
coord.ohne.spn <- coordinates(karte.ohne.spn)
coord.nur.spn <- coordinates(karte.nur.spn)
coord.nur.spn[2] <- coord.nur.spn[2] - 0.12

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
