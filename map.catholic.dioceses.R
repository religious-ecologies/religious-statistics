#!/usr/bin/env Rscript --vanilla

# Map the seats of Catholic Dioceses over time in R

# Lincoln Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggmap)
library(plyr)

# Geocode the data, using the temp file if we haven't aleady 
if (file.exists("temp/catholic.dioceses.geocoded.csv")) {
  cat("We're using the already geocoded data.\n")
  cat("Delete temp/catholic.dioceses.geocoded.csv' to redo the geocoding.\n")
  geo <- read.csv("temp/catholic.dioceses.geocoded.csv")
} else {
  dioceses <- read.csv("data/catholic.dioceses.csv", comment.char = "#")
  geo <- transform(dioceses, geo = geocode(as.character(diocese)))
  write.csv(geo, "temp/catholic.dioceses.geocoded.csv")
}

# Get the map
center <- "Lebanon, Kansas"
png(filename = "map.catholic.dioceses.png")
map <- qmap(center, zoom = 4)
map + geom_point(data = geo, aes(x = geo.lon, y = geo.lat))
dev.off()