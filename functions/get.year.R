# Function to get the year from our data, using lubridate

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

get.year <- function(date.string) {
  require(lubridate)
  result <- year(mdy(as.character(date.string)))
  return(result)
}

