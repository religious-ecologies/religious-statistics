library(readr)
library(dplyr)

methodists <- read_csv("methodists-minutes/methodist-minutes.csv")

methodists %>%
  group_by(minutes_year) %>%
  summarize(members_general = sum(members_general, na.rm = TRUE),
            members_white = sum(members_white, na.rm = TRUE),
            members_colored = sum(members_colored, na.rm = TRUE)) %>%
  write_csv("methodists-minutes/methodist-error-checking-totals.csv", na = "")
