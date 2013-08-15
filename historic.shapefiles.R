#!/usr/bin/env Rscript --vanilla

# Convert shapefiles of historical US state boundaries into R objects
#
# The shapefiles for the states were downloaded from the
#
#   Minnesota Population Center. National Historical Geographic Information 
#   System: Version 2.0. Minneapolis, MN: University of Minnesota 2011.
#   <http://www.nhgis.org>
#
# This script will perform two transformations. First, it will convert those 
# NHGIS shapefiles into R objects. These R objects can be loaded for use in 
# future projects. For example, one file will be created us.state.1790.Rdata.
# To load that file for use in a plot, one would use these commands:
#
#    library(R.utils)
#    states.1790 <- loadObject("path/to/us.state.1790.Rdata")
#
# At the same time this script will change the projection of the shapefiles 
# into WGS84. This will make the R objects suitable for use in ggplot2.
#
# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(R.utils)
library(maptools)
library(rgdal)                        # Requires binary dependencies
library(ggplot2)

shapefile.from.zip <- function(zipfile) {
  # Unzip the archive to a temporary file and return the path to the shapefile
  #
  # Args:
  #   zipfile: The path to a zipfile containing a shapefile
  #
  # Returns:
  #   The path to the unzipped .shp file
  #
  zipdir <- tempfile()
  dir.create(zipdir)
  unzip(zipfile, exdir=zipdir)
  filename <- list.files(zipdir, "*.shp$")
  path     <- paste(zipdir, filename, sep="/")
  return(path)
}

convert.shapefile <- function(shapefile, outdir, name, proj.in,
                              proj.out = "+proj=longlat +datum=WGS84" ) {
  # Convert a shapefile from one projection to another projection as an R object
  #
  # Args:
  #   shapefile: The path to a .shp shapefile
  #   outdir:    The path to the directory to store the file
  #   name:      The name of both the file to be saved and the R data frame
  #   proj.in:   The proj4string for the shapefile to be converted
  #   proj.out:  The proj4string for the shapefile to be saved. Defaults to 
  #              the value used by ggmaps.
  #
  # Returns:
  #   Returns nothing, but saves an .Rdata object with an R object suitable 
  #   for plotting in ggplot2.
  #
  shp <- readShapeSpatial(shapefile, proj4string = CRS(proj.in))
  shp <- spTransform(shp, CRS(proj.out))
  shp <- fortify(shp)
  assign(name, shp)
  saveObject(get(name), file = paste(name, ".Rdata", sep = ""), path = outdir)
}

# The original projection and paths to the zip files containing the shapefiles
projection <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs"
dir.in     <- "data/downloads/shapefiles"
dir.out    <- "data/clean/shapefiles"
files      <- list.files(path = dir.in, pattern = "*.zip", full.names = T)

# Convert each shapefile
for (f in files) {
  cat(paste("Unzipping", f, "\n"))
  shapefile <- shapefile.from.zip(f)
  name      <- sub(".*(us_.+_\\d+).zip", "\\1", f)
  name      <- gsub("_", ".", name)
  cat(paste("Converting and saving", name, "\n"))
  convert.shapefile(shapefile, outdir = dir.out, name = name, proj.in = 
                    projection)
}

