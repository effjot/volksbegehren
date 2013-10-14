#### Funktionen für Karten und statistische Plots

library(sp)
library(RColorBrewer)


### Karten zeichnen

vb.plot.map <- function(map, data, zcol = "Anzahl", main = "Volksbegehren: Anzahl Eintragungen",
                        classes = round(seq(min(data[[zcol]]), max(data[[zcol]]),
                          length.out = 10)), custom.layout = NULL,
                        join.col = "Landkreis", offset.label = "Spree-Neiße",
                        palette.name = "GnBu", palette.rev = FALSE) {

  ##  VB-Ergebnisse mit Karte verbinden
  map@data <- data.frame(map@data,
                         data[match(map@data[, join.col],
                                    data[, join.col]), ])

  ## Klassen / Farbpalette
  map$zclassif <- cut(map[[zcol]], classes,
                        labels = paste("bis", tail(classes, -1)))
  palette <- brewer.pal(nlevels(map$zclassif), palette.name)
  if (palette.rev) palette <- rev(palette)

  ## Labels versetzen wg. Überlappung
  map.without.offset <- map[map[[join.col]] != offset.label, ]
  map.with.offset <- map[map[[join.col]] == offset.label, ]
  coord.without.offset <- coordinates(map.without.offset)
  coord.with.offset <- coordinates(map.with.offset)
  coord.with.offset[2] <- coord.with.offset[2] - 0.12

  ## Plot erzeugen
  layout <- if (is.null(custom.layout)) {
    list(list("sp.text", coord.with.offset, map.with.offset[[zcol]]),
         list("sp.text", coord.without.offset, map.without.offset[[zcol]]))
  } else {
    custom.layout
  }
  spplot(map, "zclassif", col.regions = palette, col = grey(0.75),
         main = main, sp.layout = layout)
}


vb.file.standard.maps <- function(basename, karte, eintr, gemeinden = NULL,
                                  title = "Volksbegehren",
                                  anzahl.klassen = c(0, 50, 100, 200, 500, 1000, 2000, 5000, 10000),
                                  prozent.klassen = c(0, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20)) {

  if (!is.null(gemeinden)) {
    gemnd.ohne.cb <- gemeinden[gemeinden$Gemeinde != "Cottbus", ]
    gemnd.nur.cb <- gemeinden[gemeinden$Gemeinde == "Cottbus", ]
  }

  png(paste0(basename, "-anz.png"), width=480, height=480)
  print(vb.plot.map(karte, eintr, "Anzahl", classes = anzahl.klassen,
                    main = paste0(title, ": Anzahl Eintragungen")))
  dev.off()

  png(paste0(basename, "-proz.png"), width=480, height=480)
  print(vb.plot.map(karte, eintr, "Prozent", classes = prozent.klassen,
                    main = paste0(title, ": Beteiligung in Prozent")))
  dev.off()

  if (!is.null(gemeinden)) {
    png(paste0(basename, "-top5.png"), width=480, height=480)
    print(vb.plot.map(karte, eintr, "Anzahl", classes = anzahl.klassen,
                      main = paste0(title, ": Top-5-Gemeinden"),
                      custom.layout = list(
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
