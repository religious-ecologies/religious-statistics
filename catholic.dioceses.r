#!/usr/bin/env Rscript --vanilla

# Map the seats of Catholic dioceses over time in R

# Lincoln Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggplot2)
library(ggthemes)
library(maps)
library(plyr)
library(R.utils)
library(grid)
source("functions/get.year.r")

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

canada <- map_data("world", "Canada")
mexico <- map_data("world", "Mexico")
us     <- map_data("usa")

my_theme <- theme_tufte() +
  theme(panel.border = element_blank(),
        axis.ticks   = element_blank(),
        axis.text    = element_blank(),
        axis.title   = element_blank(),
        plot.title   = element_text(size = 8),
        panel.margin = unit(0, "null"),
        plot.margin  = rep(unit(0, "null"), 4))

# Given a year, plot the dioceses in existence that year
PlotDioceses <- function(plot.year) {

  # Select the data for this year
  dioceses <- subset(geo, get_year(date.erected) <= plot.year)
  metropolitans <- subset(geo, get_year(date.metropolitan) <= plot.year) 
  states <- loadObject(paste("data/clean/us.state.",
                             plot.year, ".Rdata", sep=""))

  # Map the dioceses. Dots for archdioceses will cover dioceses
  png(filename =
      paste("outputs/catholic-dioceses/dioceses.", plot.year, ".png", sep=""),
      width = 1500, height = 800, units = "px", res = 300)
  plot <- ggplot(data = dioceses, aes(x = geo.lon, y = geo.lat)) +
  coord_map() +
  xlim(-125, -60) +
  ylim(24, 50) +
  my_theme + 
  geom_path(data = us, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = 0.2) +
  geom_path(data = canada, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = 0.2) +
  geom_path(data = mexico, aes(x = long, y = lat, group = group),
            color = 'gray', fill = 'white', size = 0.2) +
  geom_path(data = states, aes(x = long, y = lat, group = group),
          color = 'gray', fill = 'white', size = 0.2) +
  geom_point(data = dioceses, colour="red", size = 1,
             aes(x = geo.lon, y = geo.lat)) + 
  geom_point(data = metropolitans, colour="purple", size = 2,
           aes(x = geo.lon, y = geo.lat)) +
  ggtitle(paste("Catholic Dioceses,", plot.year))
  cat("Printing the plot for ", plot.year, ".\n", sep = "")
  print(plot)
  dev.off()

}

# Plot every decade since 1790
years <- seq(1790, 2000, 10)

for(year in years) {
  PlotDioceses(year)
}

# Make an animated GIF
system("convert -delay 100 outputs/catholic-dioceses/*.png outputs/catholic-dioceses/dioceses.animation.gif")

