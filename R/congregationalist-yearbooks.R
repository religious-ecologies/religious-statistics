# Script to concatenate and geocode Congregationalist yearbooks

library(dplyr)
library(ggmap)
library(mullenMisc)
library(stringr)

dir <- "data/congregationalist-yearbooks/"
files <- Sys.glob(paste0(dir, "congregationalist-yearbook-*.csv"))

data <- lapply(files, read.csv, stringsAsFactors = FALSE) %>%
  rbind_all

cities <- data %>%
  group_by(city, state) %>%
  summarize(place = paste(city, state)[1])

geo  <- geocode(cities$place, override_limit = TRUE)

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
data[data$city == "Quebec", ]$lon <- -71.2428
data[data$city == "Quebec", ]$lat <- 46.80328
data[data$city == "English River, Williamstown", ]$lon <- -74.57957
data[data$city == "English River, Williamstown", ]$lat <- 45.14667
data[data$city == "Mill Plain", ]$lon <- -73.26126
data[data$city == "Mill Plain", ]$lat <- 41.14084
data[data$city == "Ellsworth", ]$lon <- -72.64370
data[data$city == "Ellsworth", ]$lat <- 41.85260
data[data$city == "Chatham", ]$lon <- -72.5000
data[data$city == "Chatham", ]$lat <- 41.5667
data[data$city == "Alamo", ]$lon <- -85.6939
data[data$city == "Alamo", ]$lat <- 42.3808
data[data$city == "Washington Village", ]$lon <- 41.688333
data[data$city == "Washington Village", ]$lat <- -71.566667
data[data$city == "Albion and Bolton Village", ]$lon <- -79.843889
data[data$city == "Albion and Bolton Village", ]$lat <- 43.923889

multiple_cities <- data %>%
  group_by(city, state) %>%
  summarize(n = n(),
            place = paste(city, state)[1]) %>%
  filter(n > 1)

# Jitter the points if they need it
data <- data %>%
  rowwise() %>%
  mutate(jlat = ifelse(paste(city, state) %in% multiple_cities$place,
                       jitter_latlong(lat, type = "lat"), lat)) %>%
  mutate(jlon = ifelse(paste(city, state) %in% multiple_cities$place,
                       jitter_latlong(lon, type = "long", latitude = lat), lon))


url <- function(page) {
  paste0("https://archive.org/stream/americancongrega04amer#page/"
         page,"/mode/1up")
}

data <- data %>%
  mutate(url = citation %>%
           str_match("p. \\d{2,3}") %>%
           str_sub(start = 4) %>%
           url())

write.csv(data, file = paste0(dir, "congregationalists-geocoded.csv"),
          row.names = FALSE)
