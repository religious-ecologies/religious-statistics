#!/usr/bin/env Rscript --vanilla

# Map missions of the Paulist Fathers over time

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggmap)
library(lubridate)
library(plyr)
source("functions/get.year.R")

# Download and geocode the data or use the cache
if (file.exists("data-generated/paulist.missions.csv")) {
  missions <- read.csv("data-generated/paulist.missions.csv",
                       comment.char = "#", stringsAsFactors = F)
} else {
  if (! file.exists("data-downloaded/paulist.missions.csv")) {
    system("curl 'https://docs.google.com/spreadsheet/pub?key=0AtQHB1QuuzwldEVScGphLWMtVjZHNDRnR2ZaMW1Lamc&single=true&gid=0&output=csv' -o data-downloaded/paulist.missions.csv")
  } 
  raw <- read.csv("data-downloaded/paulist.missions.csv",
                  comment.char = "#", stringsAsFactors = F)
  raw <- transform(raw, location = paste(city, state, sep = ", "))
  missions <- transform(raw, geo = geocode(as.character(location)))
  write.csv(missions, "data-generated/paulist.missions.csv")
} 

# Clean up the data
missions <- transform(missions, year = get.year(start.date))
missions <- subset(missions, !is.na(year))

# Get the map
center <- "Lexington, KY"
map <- qmap(center, zoom = 5)

# Map the missions
png(filename = "outputs/map.paulist.missions.png",
    width=11, height=8.5, units="in", res=300)
plot <- map + 
geom_point(data = missions, 
           aes(x = geo.lon, y = geo.lat, size = converts)) + 
ggtitle("Paulist Missions") +
theme(legend.position = "none") +
facet_wrap(~ year, 3, 6)
print(plot)
dev.off()

