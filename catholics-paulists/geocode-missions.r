library(plyr)
library(lubridate)
library(ggmap)

raw <- read.csv("data/paulist-chronicles/paulist-missions.csv",
                stringsAsFactors = FALSE)

# Location field for geocoding
raw$location <- paste(raw$city, raw$state)

# Year field
raw$year <- year(mdy(raw$start_date))

# Give approximations of the values "several" and "many"; replace NA with 0
raw$converts[raw$converts == "several"] <- 3
raw$converts[raw$converts == "many"]    <- 7
raw$converts <- as.integer(raw$converts)
raw$converts[is.na(raw$converts)]       <- 0

# Count converts and those left under instruction together
raw$under_instruction <- as.integer(raw$under_instruction)
raw$under_instruction[is.na(raw$under_instruction)]       <- 0
raw$converts_total <- raw$converts + raw$under_instruction

# Geocode
geocoded <- transform(raw, geo = geocode(location))

write.csv(geocoded, "data/paulist-chronicles/paulist-missions.geocoded.csv",
          row.names = FALSE)
