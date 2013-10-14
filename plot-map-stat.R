#### Funktionen für Karten und statistische Plots

library(sp)
library(RColorBrewer)


### Karten zeichnen

plot.vb.karten.to.file <- function(basename, karte, eintr, gemeinden = NULL,
                                   title = "Volksbegehren",
                                   anzahl.klassen = c(0, 50, 100, 200, 500, 1000, 2000, 5000, 10000),
                                   prozent.klassen = c(0, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20)) {

  ## VB-Ergebnisse mit Karte verbinden

  karte@data <- data.frame(karte@data,
                           eintr[match(karte@data[, "Landkreis"],
                                       eintr[, "Landkreis"]), ])

  ## Klasseneinteilung

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

  if (!is.null(gemeinden)) {
    gemnd.ohne.cb <- gemeinden[gemeinden$Gemeinde != "Cottbus", ]
    gemnd.nur.cb <- gemeinden[gemeinden$Gemeinde == "Cottbus", ]
  }

  png(paste0(basename, "-anz.png"), width=480, height=480)
  print(spplot(karte, "anz.klassif", col.regions = anz.palette, col = grey(0.75),
               main = paste0(title, ": Anzahl Eintragungen"),
               sp.layout = list(
                 list("sp.text", coord.nur.spn, karte.nur.spn$Anzahl),
                 list("sp.text", coord.ohne.spn, karte.ohne.spn$Anzahl))))
  dev.off()

  png(paste0(basename, "-proz.png"), width=480, height=480)
  print(spplot(karte, "proz.klassif", col.regions = proz.palette, col = grey(0.75),
               main = paste0(title, ": Beteiligung in Prozent"),
               sp.layout = list(
                 list("sp.text", coord.nur.spn, karte.nur.spn$Prozent),
                 list("sp.text", coord.ohne.spn, karte.ohne.spn$Prozent))))
  dev.off()

  if (!is.null(gemeinden)) {
    png(paste0(basename, "-top5.png"), width=480, height=480)
    print(spplot(karte, "anz.klassif", col.regions = anz.palette, col = grey(0.75),
                 main = paste0(title, ": Top-5-Gemeinden"),
                 sp.layout = list(
                   list("sp.points", gemeinden, pch = 16, col = "red", cex = 1.5),
                   list("sp.text", coordinates(gemnd.ohne.cb),
                        gemnd.ohne.cb$Anzahl, adj = c(1.2, 1.2), cex = 1.5),
                   list("sp.text", coordinates(gemnd.nur.cb), gemnd.nur.cb$Anzahl,
                        pos = 4, cex = 1.5))))
    dev.off()
  }
}


### Entfernungsabhängigkeit

plot.dist.rel.to.file <- function() {

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

}
