library(sp)


### Zwischenstand Landeswahlleiter 10.07.13 laden
eintr <- read.csv("zwischenstand.csv", as.is = TRUE)


### Landkreise in Deutschland von http://gadm.org/
load("DEU_adm3.RData")

## Brandenburgische Landkreise ausschneiden
karte <- gadm[gadm$NAME_1 == "Brandenburg", ]

## Namen bereinigen (kreisfr. Städte)
karte$NAME_3 <- gsub(" Städte", "", karte$NAME_3)


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
