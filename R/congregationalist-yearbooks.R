# Script to concatenate and geocode Congregationalist yearbooks

library(dplyr)
library(ggmap)

dir <- "data/congregationalist-yearbooks/"
files <- Sys.glob(paste0(dir, "congregationalist-yearbook-*.csv"))

data <- lapply(files, read.csv, stringsAsFactors = FALSE) %>%
  rbind_all

cities <- data %>%
  group_by(city, state) %>%
  summarize(place = paste(city, state)[1])

geo  <- geocode(cities$place)

cities <- cities %>%
  cbind(geo) %>%
  select(-place)

data <- data %>%
  left_join(cities)

write.csv(data, file = paste0(dir, "congregationalists-geocoded.csv"),
          row.names = FALSE)
