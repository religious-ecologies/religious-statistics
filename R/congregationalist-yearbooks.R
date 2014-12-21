# Script to concatenate and geocode Congregationalist yearbooks

library(dplyr)
library(ggmap)

dir <- "data/congregationalist-yearbooks/"
files <- Sys.glob(paste0(dir, "congregationalist-yearbook-*.csv"))

data <- lapply(files, read.csv, stringsAsFactors = FALSE) %>%
  rbind_all

cities <- data %>%
  group_by(city, state, church) %>%
  summarize(place = paste(church, city, state)[1])

geo  <- geocode(cities$place)

cities <- cities %>%
  cbind(geo) %>%
  select(-place)

data <- data %>%
  left_join(cities)

data[data$city == "Burford and Paris", ]$lon <- -80.42914
data[data$city == "Burford and Paris", ]$lat <- 43.10328
data[data$city == "English River, Williamstown", ]$lon <- -93.18904
data[data$city == "English River, Williamstown", ]$lat <- 50.63601
data[data$city == "Esquesing", ]$lon <- -79.88752
data[data$city == "Esquesing", ]$lat <- 43.54965
data[data$city == "Fall River" & data$state == "RI", ]$lon <- -71.15505
data[data$city == "Fall River" & data$state == "RI", ]$lat <- 41.70149
data[data$city == "New Castle", ]$lon <- -70.71608
data[data$city == "New Castle", ]$lat <- 43.07246
data[data$city == "Oro, Innisfil, and Argus", ]$lon <- -79.61124
data[data$city == "Oro, Innisfil, and Argus", ]$lat <- 44.51272

write.csv(data, file = paste0(dir, "congregationalists-geocoded.csv"),
          row.names = FALSE)
