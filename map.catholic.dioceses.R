#!/usr/bin/env Rscript --vanilla

# Map the seats of Catholic Dioceses over time in R

# Lincoln Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggmap)
library(plyr)

# Geocode the data if we haven't already; otherwise use the saved data
if (file.exists("temp/catholic.dioceses.geocoded.csv")) {
  cat("We're using the already geocoded data.\n")
  cat("Delete temp/catholic.dioceses.geocoded.csv' to redo the geocoding.\n")
  geo <- read.csv("temp/catholic.dioceses.geocoded.csv")
} else {
  dioceses <- read.csv("data/catholic.dioceses.csv", comment.char = "#")
  geo <- transform(dioceses, geo = geocode(as.character(diocese)))
  write.csv(geo, "temp/catholic.dioceses.geocoded.csv")
}

# Only the continental United States
geo <- subset(geo, 25 < geo.lat & geo.lat < 50)

# Get the map
center <- c(lon = -96.5, lat = 39.0911161) 
map <- qmap(center, zoom = 4)

# Plot the map with points
png(filename = "outputs/map.catholic.dioceses.png",
  width=2000, height=2000, res=300)
map + geom_point(data = geo, aes(x = geo.lon, y = geo.lat))
dev.off()