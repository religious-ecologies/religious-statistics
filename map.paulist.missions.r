#!/usr/bin/env Rscript --vanilla

# Map missions of the Paulist Fathers over time
# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggmap)
library(ggplot2)
library(lubridate)
library(plyr)
library(RCurl)
library(R.utils)
library(RColorBrewer)
source("functions/get.year.r")
source("functions/geocode-and-cache.r")


# Data preparation
# -------------------------------------------------------------------
if (!file.exists("data/downloads/paulist-missions.csv")) {
  cat("Downloading the Paulist mission data from Google spreadsheets.\n")
  download <- getURL("https://docs.google.com/spreadsheet/pub?key=0AtQHB1QuuzwldEVScGphLWMtVjZHNDRnR2ZaMW1Lamc&single=true&gid=0&output=csv")
  dataset <- read.csv(textConnection(download), stringsAsFactors = F)
  dataset <- transform(dataset, location = paste(city, state))
  write.csv(dataset, file = "data/downloads/paulist-missions.csv")
} 

missions <- geocode_and_cache("data/downloads/paulist-missions.csv", 
                              "data/clean/paulist-missions.geocoded.csv",
                              "location")

missions <- transform(missions, year = get_year(start.date))

# Give approximations of the values "several" and "many"
missions$converts[missions$converts == "several"] <- 3
missions$converts[missions$converts == "many"]    <- 7
missions$converts <- as.integer(missions$converts)

# Map of missions before Civil War
# -------------------------------------------------------------------
missions_cw <- subset(missions, year < 1866)
map_1860    <- loadObject("data/clean/us.state.1860.Rdata")

# png(filename = "outputs/map.paulist.missions.png",
#     width=11, height=8.5, units="in", res=300)
plot <- ggplot() +
geom_path(data = map_1860, 
          aes(x = long, y = lat, group = group),
          color = 'gray', fill = 'white', size = .5) +
coord_map() +
xlim(-96, -65) +
geom_point(data = missions_cw,
           aes(x = geo.lon, y=geo.lat, size = communion.general),
           alpha = 0.5) +
geom_density2d(data = missions_cw,
               aes(x = geo.lon, y=geo.lat),
               color = 'black', alpha = 0.4)+
ggtitle("Redemptorist and Paulist Missions, 1852-1865 ") +
theme_bw() 
print(plot)
# dev.off()

ggsave(filename = paste(date(), ".png", sep=""))

# Map of missions after Civil War
missions_post <- subset(missions, year >= 1866)
map_1880    <- loadObject("data/clean/us.state.1880.Rdata")

# png(filename = "outputs/map.paulist.missions.png",
#     width=11, height=8.5, units="in", res=300)
plot <- ggplot() +
geom_polygon(data = map_1880, 
             aes(x = long, y = lat, group = group),
             color = 'gray', fill = 'white', size = .5) +
coord_map() +
xlim(-125,-66) +
ylim(24, 50) +
geom_point(data = missions_post,
           aes(x = geo.lon, y=geo.lat, size = communion.general),
           alpha = 0.5) +
geom_density2d(data = missions_post,
               aes(x = geo.lon, y=geo.lat),
               color = 'black', alpha = 0.4)+
ggtitle("Paulist Missions after 1865")
print(plot)
# dev.off()

# Map of missions in Minnesota
# -------------------------------------------------------------------


# Map of missions in greater New York 
# -------------------------------------------------------------------

# Misc ideas 
# -------------------------------------------------------------------

# theme(legend.position = "none")
# geom_hex(data = missions_cw,
#            aes(x = geo.lon, y = geo.lat, size=communion.general),
#            bins = 100, alpha = 0.90) +
