# Function to geocode a file and cache it

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

geocode_and_cache <- function(raw_file, geo_file, column) {
  # Use the cached version of a geocoded file; otherwise, geocode the data and 
  # cache it
  #
  # Args:
  #   raw_file: The path to the ungeocoded .csv file
  #   geo_file: The path to the geocoded .csv file
  #   column: The column in the dataframe that contains location to be coded
  # 
  # Returns:
  #   A data frame from the .csv file

  require(plyr)
  require(ggmap)

  if (file.exists(geo_file)) {
    cat("Using the cached geocoded file.\n") 
    geo_data <- read.csv(geo_file, comment.char = "#", stringsAsFactors = F)
    return(geo_data)
  } else {
    cat("Geocoding and caching the file.\n") 
    raw_data <- read.csv(raw_file, comment.char = "#", stringsAsFactors = F)
    print(column)
    # Reason for bizarre syntax:
    # http://stackoverflow.com/questions/6955128/object-not-found-error-with-ddply-inside-a-function
    geo_data <- do.call("ddply",list(raw_data,
                                     as.character(column),
                                     transform,
                                     geo = call("geocode", as.symbol(column))))
    write.csv(geo_data, geo_file)
    return(geo_data)
  } 
}
