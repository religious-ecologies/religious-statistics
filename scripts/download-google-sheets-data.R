# This script downloads CSV files from Google Sheets and saves them to the
# appropriate place in the repository

library("googlesheets")

# Methodists
"1Ql2-sHAY3BuBmmW3LsX54e3oBUYmqMfLfLsAIsgZoGc" %>%
  gs_key() %>%
  gs_download(ws = "main", to = "methodists-minutes/methodist-minutes.csv",
              overwrite = TRUE)

# Episcopalians
"1pnRkIK_aJwKrXkM1DhXkHH-g_PINWahNCeeCEx6iKIE" %>%
  gs_key() %>%
  gs_download(to = "episcopal-yearbooks/episcopal-yearbooks-yearly.csv",
              overwrite = TRUE)
