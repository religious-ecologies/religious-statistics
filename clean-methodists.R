library("readr")
library("dplyr")

d <- read_csv("methodists-minutes/methodist-minutes.csv")

d[d$minutes_year >= 1786 & is.na(d$members_white), "members_white"] <- 0
d[d$minutes_year >= 1786 & is.na(d$members_colored), "members_colored"] <- 0

d <- d %>%
  mutate(members_general = ifelse(is.na(members_general),
                                  members_white + members_colored,
                                  members_general))

