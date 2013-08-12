#!/usr/bin/env Rscript --vanilla

# Map missions of the Paulist Fathers over time

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggmap)
library(lubridate)
library(plyr)

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


