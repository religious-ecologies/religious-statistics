# Aggregate the missions by location

library(plyr)

raw <- read.csv("data/paulist-chronicles/paulist-missions.geocoded.csv")

aggregated <- ddply(raw, .(city, state, year), summarize,
                    long = max(geo.lon),
                    lat =  max(geo.lat),
                    confessions = sum(confessions_total, na.rm = TRUE),
                    converts = sum(converts_total, na.rm = TRUE),
                    number_missions = length(location)) 

write.csv(aggregated, 
          "data/paulist-chronicles/paulist-missions.aggregated.csv",
          row.names = FALSE)

  