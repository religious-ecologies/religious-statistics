#!/usr/bin/env Rscript --vanilla

# Map the seats of Catholic dioceses over time in R

# Lincoln Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggmap)
library(lubridate)
library(plyr)
source("functions/get.year.R")

# Geocode the data if we haven't already; otherwise use the saved data
if (file.exists("data/clean/catholic.dioceses.geocoded.csv")) {
  cat("We're using the already geocoded data.\n")
  geo <- read.csv("data/clean/catholic.dioceses.geocoded.csv")
} else {
  raw.us <- read.csv("data/csv/catholic.dioceses.us.csv", comment.char = "#")
  raw.canada <- read.csv("data/csv/catholic.dioceses.canada.csv", comment.char = "#")
  raw.mexico <- read.csv("data/csv/catholic.dioceses.mexico.csv", comment.char = "#")
  raw <- rbind(raw.us, raw.canada, raw.mexico)
  geo <- transform(raw, geo = geocode(as.character(diocese)))
  write.csv(geo, "data/clean/catholic.dioceses.geocoded.csv")
}

# Get the map
center <- c(lon = -96.1, lat = 40) 
map <- qmap(center, zoom = 4)

# Given a year, plot the dioceses in existence that year
PlotDioceses <- function(plot.year) {

  # Select the data for this year
  dioceses <- subset(geo, get.year(date.erected) <= plot.year)
  metropolitans <- subset(geo, get.year(date.metropolitan) <= plot.year) 

  # Map the dioceses. Dots for archdioceses will cover dioceses
  png(filename =
   paste("outputs/catholic-dioceses/dioceses.", plot.year, ".png", sep = ""),
   width=1200, height=1200, res=300)
  plot <- map + 
  geom_point(data = dioceses, colour="red", size = 1,
   aes(x = geo.lon, y = geo.lat)) + 
  geom_point(data = metropolitans, colour="purple", size = 2,
   aes(x = geo.lon, y = geo.lat)) +
  ggtitle(paste("Catholic Dioceses,", plot.year))
    print(plot)
    dev.off()

  }

# Plot every decade since 1790
years <- seq(1790, 2010, 10)
for (year in years) {
  PlotDioceses(year)
}

