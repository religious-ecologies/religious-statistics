# R script to chart demographic data on American Judaism

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(ggplot2)

# Load functions for attribution
# -------------------------------------------------------------------
source("../attribution.R")

# Data
data <- read.csv("sarna.appendix.csv", comment.char = "#")

# Population estimates as line charts
# -------------------------------------------------------------------
png(filename = "jewish-pop.old.png",
    width =2000, height=2000, res=300)
ggplot(data) +
geom_line(aes(data$year, data$estimate.low)) + 
geom_line(aes(data$year, data$estimate.high)) +
labs(title="American Jewish Population Estimates, 1660-2000",
     x = "Year",
     y = "Population")
attribution("Data: Jonathan Sarna, American Judaism.")
dev.off()

# Calculate mean/midpoint and the height of the error bars
# -------------------------------------------------------------------
midpoint <- (data$estimate.high + data$estimate.low)/2 
error <- (data$estimate.high - data$estimate.low)/2

# Population estimates with error bars
# -------------------------------------------------------------------
png(filename = "jewish-pop.png",
    width=2000, height=2000, res=300)
ggplot(data) +
geom_line(aes(data$year, midpoint)) +
geom_errorbar(aes(
                  x=data$year,
                  ymin = midpoint - error,
                  ymax = midpoint + error))+
labs(title="American Jewish Population Estimates, 1660-2000",
     x = "Year",
     y = "Population")
attribution("Data: Jonathan Sarna, American Judaism.")
dev.off()

# Population estimates for 19th century
# -------------------------------------------------------------------
png(filename = "jewish-pop.early-19c.png",
    width=2000, height=2000, res=300)
ggplot(data[3:8,]) +
geom_line(aes(data$year[3:8], midpoint[3:8])) +
geom_errorbar(aes(
                  x=data$year[3:8],
                  ymin = midpoint[3:8] - error[3:8],
                  ymax = midpoint[3:8] + error[3:8]))+
labs(title="American Jewish Population Estimates, 1776-1840",
     x = "Year",
     y = "Population")
attribution("Data: Jonathan Sarna, American Judaism.")
dev.off()

# Population estimates late 19th century
# -------------------------------------------------------------------
png(filename = "jewish-pop.late-19c.png",
    width=2000, height=2000, res=300)
ggplot(data[9:13,]) +
geom_line(aes(data$year[9:13], midpoint[9:13])) +
geom_errorbar(aes(
                  x=data$year[9:13],
                  ymin = midpoint[9:13] - error[9:13],
                  ymax = midpoint[9:13] + error[9:13]))+
labs(title="American Jewish Population Estimates, 1850-1900",
     x = "Year",
     y = "Population")
attribution("Data: Jonathan Sarna, American Judaism.")
dev.off()
