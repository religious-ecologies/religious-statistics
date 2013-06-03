#!/usr/bin/env Rscript --vanilla

# Map the seats of Catholic dioceses over time in R

# Lincoln Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggmap)
library(lubridate)
library(plyr)

# Geocode the data if we haven't already; otherwise use the saved data
if (file.exists("temp/catholic.dioceses.geocoded.csv")) {
  cat("We're using the already geocoded data.\n")
  cat("Delete temp/catholic.dioceses.geocoded.csv' to redo the geocoding.\n")
  geo <- read.csv("temp/catholic.dioceses.geocoded.csv")
  } else {
    raw <- read.csv("data/catholic.dioceses.csv", comment.char = "#")
    geo <- transform(raw, geo = geocode(as.character(diocese)))
    write.csv(geo, "temp/catholic.dioceses.geocoded.csv")
  }

# Only the continental United States
geo <- subset(geo, 25 < geo.lat & geo.lat < 50)

# Get the map
center <- c(lon = -96.5, lat = 39.0911161) 
map <- qmap(center, zoom = 4)

# Function to get the year from our data, using lubridate
GetYear <- function(date.string) {
 result <- year(mdy(as.character(date.string)))
 return(result)
}

# Given a year, plot the dioceses in existence that year
PlotDioceses <- function(plot.year) {

  # Select the data for this year
  dioceses <- subset(geo, GetYear(date.erected) <= plot.year)
  metropolitans <- subset(geo, GetYear(date.metropolitan) <= plot.year) 

  # Map the dioceses. Dots for archdioceses will cover dioceses
  png(filename =
   paste("outputs/map.catholic.dioceses.", plot.year, ".png", sep = ""),
   width=2000, height=2000, res=300)
  plot <- map + 
  geom_point(data = dioceses, colour="red", size = 2,
   aes(x = geo.lon, y = geo.lat)) +
  geom_point(data = metropolitans, colour="purple", size = 4,
   aes(x = geo.lon, y = geo.lat)) +
  ggtitle(paste("Catholic Dioceses and Archdioceses,", plot.year))
    print(plot)
    dev.off()

  }

# Plot every decade since 1790, plus 1963 (the last year with data)
years <- c(seq(1790, 1960, 10), 1963)
for (year in years) {
  PlotDioceses(year)
}
