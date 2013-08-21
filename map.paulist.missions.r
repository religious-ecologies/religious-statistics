#!/usr/bin/env Rscript --vanilla

# Map missions of the Paulist Fathers over time

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggmap)
library(lubridate)
library(plyr)
source("functions/get.year.R")

# Download and geocode the data or use the cache



if (file.exists("data/clean/paulist.missions.csv")) {
  missions <- read.csv("data/clean/paulist.missions.csv",
                       comment.char = "#", stringsAsFactors = F)
} else {
  if (! file.exists("data/downloads/paulist.missions.csv")) {
    system("curl 'https://docs.google.com/spreadsheet/pub?key=0AtQHB1QuuzwldEVScGphLWMtVjZHNDRnR2ZaMW1Lamc&single=true&gid=0&output=csv' -o data-downloaded/paulist.missions.csv")
  } 
  raw <- read.csv("data/downloads/paulist.missions.csv",
                  comment.char = "#", stringsAsFactors = F)
  raw <- transform(raw, location = paste(city, state, sep = ", "))
  missions <- transform(raw, geo = geocode(as.character(location)))
  write.csv(missions, "data/clean/paulist.missions.csv")
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
stat_density2d(aes(x = geo.lon, y = geo.lat, fill = ..level.., alpha = 
                   ..level..), size = 2, bins = 20, data = missions, geom = 
"polygon") +
ggtitle("Paulist Missions") +
theme(legend.position = "none")
print(plot)
dev.off()

# With shapefiles

# library(maptools)
# library(gpclib)
# library(sp)
# library(rgeos)
# gpclibPermit()


# unzip('census.zip'); library(maptools); library(gpclib); library(sp); gpclibPermit()
# shapefile <- readShapeSpatial('tr48_d00.shp', proj4string = CRS("+proj=longlat +datum=WGS84"))
# data <- fortify(shapefile)
# qmap('texas', zoom = 6, maptype = 'satellite') +
# geom_polygon(aes(x = long, y = lat, group = group), data = dat

# shapefile <- readShapeSpatial('data-downloaded/shapefiles/US_state_1870.shp',
#                               proj4string = CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs"))
# states.1870 <- fortify(shapefile)
# png(filename = "outputs/map.paulist.missions.borders.png",
#     width=11, height=8.5, units="in", res=300)
# plot <- map + 
# geom_point(data = missions, 
#            aes(x = geo.lon, y = geo.lat, size = converts)) + 
# ggtitle("Paulist Missions") +
# theme(legend.position = "none") +
# geom_polygon(data = states.1870, aes(x = long, y = lat, group = group),
#              colour = 'white', fill = 'black', alpha = 
#              .4, size = .3)
# print(plot)
# dev.off()


# read.csv("data-generated/paulist.missions.csv", stringAsFactors = F)

# library(maptools)

# shapefile <- readShapeSpatial('data-downloaded/shapefiles/US_state_1790.shp', proj4string = CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs"))
# shp <- spTransform(shapefile, CRS("+proj=longlat +datum=WGS84"))
# shape <- fortify(shp)
# ggplot() + geom_polygon(aes(x = long, y = lat, group = group), data = shape, color = 'gray', fill = 'red', alpha = .4) + geom_jitter(data = missions, aes(x = geo.lon, y = geo.lat))
