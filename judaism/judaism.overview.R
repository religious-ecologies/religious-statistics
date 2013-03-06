# R script to chart demographic data on American Judaism

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggplot2)

# Load functions for attribution
# -------------------------------------------------------------------
source("../attribution.R")

# Data
data <- read.csv("sarna.appendix.csv", comment.char = "#")

# Population estimates
# -------------------------------------------------------------------
png(filename = "jewish-pop.old.png", width =2000, height=2000, res=300)
ggplot(data) +
geom_line(aes(data$year, data$estimate.low)) + 
geom_line(aes(data$year, data$estimate.high)) +
labs(title="American Jewish Population Estimates, 1660-2000",
     x = "Year",
     y="Population")
credit("Data: Jonathan Sarna, American Judaism.")
dev.off()

# Population estimates with error bars
# -------------------------------------------------------------------
# Calculate mean/midpoint and the height of the error bars
midpoint <- (data$estimate.high + data$estimate.low)/2 
error <- (data$estimate.high - data$estimate.low)/2
png(filename = "jewish-pop.png", width=2000, height=2000, res=300)
ggplot(data) +
geom_line(aes(data$year, midpoint)) +
geom_errorbar(aes(
                  x=data$year,
                  ymin = midpoint - error,
                  ymax = midpoint + error))+
labs(title="American Jewish Population Estimates, 1660-2000",
     x = "Year",
     y="Population")
attribution("Data: Jonathan Sarna, American Judaism.")
dev.off()
