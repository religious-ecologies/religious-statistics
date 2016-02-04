#!/usr/bin/env Rscript --vanilla
# This script downloads CSV files from Google Sheets and saves them to the
# appropriate place in the repository

# library(googlesheets)
library(magrittr)

# Methodists
# "1Ql2-sHAY3BuBmmW3LsX54e3oBUYmqMfLfLsAIsgZoGc" %>%
#   gs_key() %>% gs_read_csv()
#   gs_download(ws = "main", to = "methodists-minutes/methodist-minutes.csv",
#               overwrite = TRUE)
download.file("https://docs.google.com/spreadsheets/d/1Ql2-sHAY3BuBmmW3LsX54e3oBUYmqMfLfLsAIsgZoGc/pub?gid=0&single=true&output=csv",
              destfile = "methodists-minutes/methodist-minutes.csv")

# Episcopalians yearly summary
# "1pnRkIK_aJwKrXkM1DhXkHH-g_PINWahNCeeCEx6iKIE" %>%
#   gs_key() %>%
#   gs_download(to = "episcopal-yearbooks/episcopal-yearbooks-yearly.csv",
#               overwrite = TRUE)
download.file("https://docs.google.com/spreadsheets/d/1pnRkIK_aJwKrXkM1DhXkHH-g_PINWahNCeeCEx6iKIE/pub?gid=0&single=true&output=csv",
              destfile = "episcopal-yearbooks/episcopal-yearbooks-yearly.csv")
