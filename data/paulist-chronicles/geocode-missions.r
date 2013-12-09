library(plyr)
library(ggmap)

raw <- read.csv("data/paulist-chronicles/paulist-missions.csv",
                stringsAsFactors = FALSE)

raw$location <- paste(raw$city, raw$state)

geocoded <- transform(raw, geo = geocode(location))

write.csv(geocoded, "data/paulist-chronicles/paulist-missions.geocoded.csv",
          row.names = FALSE)
