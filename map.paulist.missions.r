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
library(reshape2)
library(maps)
library(rgdal)
source("functions/get.year.r")
source("functions/geocode-and-cache.r")
source("functions/multiplot.r")


# Data preparation --------------------------------------------------------
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

# Download the summary data
if (!file.exists("data/downloads/paulist-summary.csv")) {
  cat("Downloading the Paulist summary data from Google spreadsheets.\n")
  download <- getURL("https://docs.google.com/spreadsheet/pub?key=0AtQHB1QuuzwldDlEZUZNZzYtazV1aVk0aGsxRkN4OWc&output=csv")
  summary <- read.csv(textConnection(download),
                      stringsAsFactors = F,
                      comment.char="#")
  write.csv(summary, file = "data/downloads/paulist-summary.csv")
} 

missions_summary <- read.csv("data/downloads/paulist-summary.csv",
                    stringsAsFactors = F,
                    comment.char = "#")


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

# Maps of Canada and Mexico
# -------------------------------------------------------------------
canada <- map_data("world", "Canada")
mexico <- map_data("world", "Mexico")

# Map of missions before Civil War
# -------------------------------------------------------------------
missions_cw <- subset(missions, year < 1866)
map_1860    <- loadObject("data/clean/us.state.1860.low-res.Rdata")

pdf(file = "outputs/paulists/paulists-map-pre-civil-war.pdf",
    height = 8.5, width = 11)

plot <- ggplot() +
coord_map() +
geom_path(data = map_1860, 
          aes(x = long, y = lat, group = group),
          color = 'gray', fill = 'white', size = .3) +
geom_path(data = canada, aes(x = long, y = lat, group = group),
          color = 'gray', fill = 'white', size = .3) +
geom_path(data = mexico, aes(x = long, y = lat, group = group),
          color = 'gray', fill = 'white', size = .3) +
xlim(-93,-65) +
ylim(23, 49) +
geom_point(data = missions_cw,
           aes(x = geo.lon, y=geo.lat, size = converts),
           alpha = 0.5) +
# geom_density2d(data = missions_cw,
#                aes(x = geo.lon, y=geo.lat),
#                color = 'black', alpha = 0.4, bins = 5)+
ggtitle("Redemptorist and Paulist Missions, 1852-1865 ") +
my_theme +
guides(size=guide_legend(title="Converts\nper mission")) +
scale_size(range = c(3, 8))
print(plot)

dev.off()

# Map of missions after Civil War
# -------------------------------------------------------------------
# missions_1870s <- subset(missions, year >= 1866 & year <= 1879)
# missions_1880s <- subset(missions, year >= 1880 & year <= 1889)
# map_1870       <- loadObject("data/clean/us.state.1870.low-res.Rdata")
# map_1880       <- loadObject("data/clean/us.state.1880.low-res.Rdata")
# 
# map_missions_1870s <- ggplot() +
# coord_map() +
# geom_path(data = map_1870, 
#              aes(x = long, y = lat, group = group),
#              color = 'gray', fill = 'white', size = .3) +
# geom_path(data = canada, aes(x = long, y = lat, group = group),
#           color = 'gray', fill = 'white', size = .3) +
# geom_path(data = mexico, aes(x = long, y = lat, group = group),
#           color = 'gray', fill = 'white', size = .3) +
# xlim(-126,-65) +
# ylim(23, 51) +
# geom_point(data = missions_1870s,
#            aes(x = geo.lon, y=geo.lat, size = converts),
#            alpha = 0.5) +
# geom_density2d(data = missions_1870s,
#                aes(x = geo.lon, y=geo.lat),
#                color = 'black', alpha = 0.4, bins = 5) +
# my_theme +
# theme(legend.position="bottom") +
# scale_size(range = c(2, 10)) +
# guides(size=guide_legend(title="Converts\nper mission")) +
# ggtitle("Paulist Missions, 1871-1879")
# 
# map_missions_1880s <- ggplot() +
# coord_map() +
# geom_path(data = map_1880, 
#              aes(x = long, y = lat, group = group),
#              color = 'gray', fill = 'white', size = .3) +
# geom_path(data = canada, aes(x = long, y = lat, group = group),
#           color = 'gray', fill = 'white', size = .3) +
# geom_path(data = mexico, aes(x = long, y = lat, group = group),
#           color = 'gray', fill = 'white', size = .3) +
# xlim(-126,-65) +
# ylim(23, 51) +
# geom_point(data = missions_1880s,
#            aes(x = geo.lon, y=geo.lat, size = converts),
#            alpha = 0.5) +
# geom_density2d(data = missions_1880s,
#                aes(x = geo.lon, y=geo.lat),
#                color = 'black', alpha = 0.4, bins = 5) +
# my_theme +
# theme(legend.position="bottom") +
# scale_size(range = c(2, 10)) +
# guides(size=guide_legend(title="Converts\nper mission")) +
# ggtitle("Paulist Missions, 1880-1889")
# 
# pdf(file = "outputs/paulists/paulists-map-post-civil-war.pdf",
#     height = 11, width = 8.5)
# multiplot(map_missions_1870s, map_missions_1880s, cols=1)
# dev.off()

# Map with railroads
rr <- readOGR("data/downloads/USrailshps/RR1870/", "RR1870WGS84")
rail <- fortify(rr)
map_1870       <- loadObject("data/clean/us.state.1870.low-res.Rdata")
missions_post <- subset(missions, year >= 1866 )

map_rr <- ggplot() +
coord_map() +
geom_path(data = map_1870, 
             aes(x = long, y = lat, group = group),
             color = 'gray', fill = 'white', size = .2) +
geom_path(data = canada, aes(x = long, y = lat, group = group),
          color = 'gray', fill = 'white', size = .2) +
geom_path(data = mexico, aes(x = long, y = lat, group = group),
          color = 'gray', fill = 'white', size = .2) +
geom_path(data = rail, aes(x = long, y= lat, group = group),
          color = 'black', alpha = .5, size = .3) +
xlim(-126,-65) +
ylim(23, 51) +
geom_point(data = missions_post,
           aes(x = geo.lon, y=geo.lat, size = converts),
           alpha = 0.5) +
my_theme +
theme(legend.position="bottom") +
scale_size(range = c(3, 8)) +
guides(size=guide_legend(title="Converts\nper mission")) +
ggtitle("Paulist Missions 1871-1886, with Railroads in 1870")

pdf(file = "outputs/paulists/paulists-map-post-civil-war.pdf",
    height = 8.5, width= 11)
print(map_rr)
dev.off()

system("pdftk /outputs/paulists/paulists-map-post-civil-war.pdf cat 1west
       output /outputs/paulists/paulists-map-post-civil-war.pdf")

# Converts per year
# -------------------------------------------------------------------

pdf(file = "outputs/paulists/paulist-missions.converts-per-year.pdf",
    width = 11, height = 8.5)

plot <- ggplot(data = missions, 
               aes(x = year, y = converts)) +
theme_tufte() +
geom_bar(stat = "identity") +
ggtitle("Converts per Year at Paulist Missions") +
# ylab("Converts") +
# xlab("Year") 
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
# ylab("Communions or Confessions") +
# xlab("Year") 
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


# How many converts average per year per decade did the Paulists make?

decade <- subset(missions_summary, year.start > 1850 & year.end < 1866)
mean(decade$converts)
decade <- subset(missions_summary, year.start > 1870 & year.end < 1880)
mean(decade$converts, na.rm=T)
decade <- subset(missions_summary, year.start > 1880 & year.end < 1890)
mean(decade$converts)
decade <- subset(missions_summary, year.start > 1890 & year.end < 1900)
mean(decade$converts)
decade <- subset(missions_summary, year.start > 1900 & year.end < 1910)
mean(decade$converts)

# Summary of missions ----------------------------------------------

conversions_chart <- ggplot(missions_summary, aes(x=year.start, y=converts)) +
  geom_bar(stat="identity") +
  theme_tufte(ticks=F) + 
  xlab("") +
  ylab(" ") +
  ggtitle("Converts at Paulist Missions, 1851-1907") +
  scale_x_continuous(breaks=seq(1850, 1920, 5)) +
  scale_y_discrete(breaks=seq(0, 600, 100)) +
  geom_hline(yintercept=seq(0, 500, 100), color="white", lwd=.5)

# How many missions did the Paulists have each year?

missions_melted <- melt(missions_summary, id="year.start", variable.name="mission.type", measure.vars=c("missions.noncatholic", "missions.catholic"))


missions_chart <- ggplot(missions_melted, aes(x=year.start)) +
  geom_bar(aes(y = value, fill=mission.type), stat="identity") +
  theme_tufte(ticks=F) +
  scale_fill_grey(start = 0.1, end = .6,
                  name = "Type of Mission",
                  breaks=c("missions.noncatholic","missions.catholic"),
                  labels=c("to Protestants", "to Catholics")) +
  theme(legend.position=c(.2, .7)) +
  xlab("") +
  ylab("") +
  ggtitle("Number of Paulist Missions, 1851-1907") +
  scale_x_continuous(breaks=seq(1850, 1920, 5)) +
  scale_y_discrete(breaks=seq(0, 80, 20)) +
  geom_hline(yintercept=seq(0, 80, 20), color="white", lwd=.5)

# How many confessions or commnunions
confessions_chart <- ggplot(missions_summary, aes(x=year.start, y=confessions)) +
  geom_bar(stat="identity") +
  theme_tufte(ticks=F) + 
  xlab("") +
  ylab("") +
  ggtitle("Confessions or Communnions per Year at Paulist Missions, 1851-1907") +
  scale_x_continuous(breaks=seq(1850, 1920, 5)) +
  scale_y_discrete(breaks=seq(0, 125e3, 25e3)) +
  geom_hline(yintercept=seq(0, 100e3, 25e3), color="white", lwd=.5)


pdf(file = "outputs/paulists/paulist-summaries.pdf",
    height = 11, width = 8.5)
multiplot(conversions_chart, confessions_chart, missions_chart, cols=1)
dev.off()
