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
library(ggthemes)
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

# Give approximations of the values "several" and "many"; replace NA with 0
missions$converts[missions$converts == "several"] <- 3
missions$converts[missions$converts == "many"]    <- 7
missions$converts <- as.integer(missions$converts)
missions$converts[is.na(missions$converts)]       <- 0

# Count converts and those left under instruction together
missions$under.instruction <- as.integer(missions$under.instruction)
missions$under.instruction[is.na(missions$under.instruction)]       <- 0
missions$converts <- missions$converts + missions$under.instruction

# File management
# -------------------------------------------------------------------
if (!file.exists("outputs/paulists")) {
  dir.create("outputs/paulists")
}

# Defaults for maps 
# -------------------------------------------------------------------
my_theme <- theme_tufte() +
  theme(panel.border = element_blank(),
        axis.ticks   = element_blank(),
        axis.text    = element_blank(),
        axis.title   = element_blank())

# Map of missions before Civil War
# -------------------------------------------------------------------
missions_cw <- subset(missions, year < 1866)
map_1860    <- loadObject("data/clean/us.state.1860.Rdata")

pdf(file = "outputs/paulists/paulist-missions.pre-civil-war.pdf",
    width = 8.5, height = 11)

plot <- ggplot() +
geom_path(data = map_1860, 
          aes(x = long, y = lat, group = group),
          color = 'gray', fill = 'white', size = .3) +
coord_map() +
xlim(-92,-66) +
ylim(24, 48) +
geom_point(data = missions_cw,
           aes(x = geo.lon, y=geo.lat, size = converts),
           alpha = 0.5) +
geom_density2d(data = missions_cw,
               aes(x = geo.lon, y=geo.lat),
               color = 'black', alpha = 0.4, bins = 5)+
ggtitle("Redemptorist and Paulist Missions, 1852-1865 ") +
my_theme +
guides(size=guide_legend(title="Converts\nper mission")) +
scale_size(range = c(2, 10))
print(plot)

dev.off()

# Map of missions after Civil War
# -------------------------------------------------------------------
missions_post <- subset(missions, year >= 1866)
map_1880      <- loadObject("data/clean/us.state.1880.Rdata")

pdf(file = "outputs/paulists/paulist-missions.post-civil-war.pdf",
    width = 11, height = 8.5)

plot <- ggplot() +
geom_path(data = map_1880, 
             aes(x = long, y = lat, group = group),
             color = 'gray', fill = 'white', size = .3) +
coord_map() +
xlim(-125,-66) +
ylim(24, 50) +
geom_point(data = missions_post,
           aes(x = geo.lon, y=geo.lat, size = converts),
           alpha = 0.5) +
geom_density2d(data = missions_post,
               aes(x = geo.lon, y=geo.lat),
               color = 'black', alpha = 0.4, bins = 5) +
my_theme +
theme(legend.position="bottom") +
scale_size(range = c(2, 10)) +
guides(size=guide_legend(title="Converts\nper mission")) +
ggtitle("Paulist Missions, 1871-1879")
print(plot)

dev.off()

# Converts per year
# -------------------------------------------------------------------

pdf(file = "outputs/paulists/paulist-missions.converts-per-year.pdf",
    width = 11, height = 8.5)

plot <- ggplot(data = missions, 
               aes(x = year, y = converts)) +
theme_tufte() +
geom_bar(stat = "identity") +
ggtitle("Converts per Year at Paulist Missions") +
ylab("Converts") +
xlab("Year") 
print(plot)

dev.off()


# Communions per year
# -------------------------------------------------------------------

pdf(file = "outputs/paulists/paulist-missions.communions-per-year.pdf",
    width = 11, height = 8.5)

plot <- ggplot(data = missions, 
               aes(x = year, y = communion.general)) +
theme_tufte() +
geom_bar(stat = "identity") +
ggtitle("Communions/Confessions per Year at Paulist Missions") +
ylab("Communions or Confessions") +
xlab("Year") 
print(plot)

dev.off()

# Converts per state
# -------------------------------------------------------------------

pdf(file = "outputs/paulists/paulist-missions.converts-by-state.pdf",
    width = 11, height = 8.5)

plot <- ggplot(data = missions, 
               aes(x = state, y = converts)) +
theme_tufte() +
geom_bar(stat = "identity") +
ggtitle("Converts per State or Province at Paulist Missions") +
ylab("Converts") +
xlab(NULL)
print(plot)

dev.off()

# Communions vs Converts
# -------------------------------------------------------------------

pdf(file = "outputs/paulists/paulist-missions.communions-vs-converts.pdf",
    width = 11, height = 8.5)

plot <- ggplot(data = missions, 
               aes(x = communion.general, y = converts)) +
theme_tufte() +
geom_point() +
geom_smooth() +
ggtitle("Converts by Size of Paulist Missions") +
ylab("Converts") +
xlab("Communions or Confessions")
print(plot)

dev.off()

# Histogram of converts
# -------------------------------------------------------------------

pdf(file = "outputs/paulists/paulist-missions.converts-histogram.pdf",
    width = 11, height = 8.5)

breaks <- c( 0,1, seq(5, 60, 5))
plot <- ggplot(data = missions, aes(x = converts)) +
theme_tufte() +
geom_histogram(breaks = breaks) +
scale_x_discrete(breaks = breaks) +
ggtitle("Typical Number of Converts at Paulist Missions") +
ylab("Number of missions") +
xlab("Converts")
print(plot)

dev.off()

# Histogram of communions
# -------------------------------------------------------------------

pdf(file = "outputs/paulists/paulist-missions.communions-histogram.pdf",
    width = 11, height = 8.5)

breaks <- seq(0, 10000, 1000)
plot <- ggplot(data = missions, aes(x = communion.general)) +
geom_histogram(binwidth = 1000) +
theme_tufte() +
ggtitle("Typical Size of Paulist Missions") +
ylab("Number of missions") +
xlab("Confessions or Communions")
print(plot)

dev.off()

# Misc code 
# -------------------------------------------------------------------

# ggsave(filename = paste(date(), ".png", sep=""))

# theme(legend.position = "none")
# geom_hex(data = missions_cw,
#            aes(x = geo.lon, y = geo.lat, size=communion.general),
#            bins = 100, alpha = 0.90) +
