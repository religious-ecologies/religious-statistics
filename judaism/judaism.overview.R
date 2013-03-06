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
# png(filename = "jewish-population.old.png",
#     width =2000, height=2000, res=300)
# ggplot(data) +
# geom_line(aes(data$year, data$estimate.low)) + 
# geom_line(aes(data$year, data$estimate.high)) +
# labs(title="American Jewish Population Estimates, 1660-2000",
#      x = "Year",
#      y = "Population")
# attribution("Data: Jonathan Sarna, American Judaism")
# dev.off()

# Calculate mean/midpoint and the height of the error bars
# -------------------------------------------------------------------
midpoint.population <- (data$estimate.high + data$estimate.low)/2 
error.population <- (data$estimate.high - data$estimate.low)/2
midpoint.percentage <- (data$percentage.population.high + 
                        data$percentage.population.low)/2 
error.percentage <- (data$percentage.population.high - 
                     data$percentage.population.low)/2 

# Population estimates with error.population bars
# -------------------------------------------------------------------
png(filename = "jewish-population.png",
    width=2000, height=2000, res=300)
ggplot(data) +
geom_line(aes(data$year, midpoint.population)) +
geom_errorbar(aes(
                  x=data$year,
                  ymin = midpoint.population - error.population,
                  ymax = midpoint.population + error.population))+
labs(title="American Jewish Population Estimates, 1660-2000",
     x = "Year",
     y = "Population (millions)") +
scale_y_continuous(breaks=seq(0,6e+06,1e+06),
                   labels=seq(0,6e+06,1e+06)/1e+06)
attribution("Data: Jonathan Sarna, American Judaism")
dev.off()

# Population estimates for early 19th century
# -------------------------------------------------------------------
png(filename = "jewish-population.early-19c.png",
    width=2000, height=2000, res=300)
ggplot(data[3:8,]) +
geom_line(aes(data$year[3:8], midpoint.population[3:8])) +
geom_errorbar(aes(
                  x=data$year[3:8],
                  ymin = midpoint.population[3:8] - error.population[3:8],
                  ymax = midpoint.population[3:8] + error.population[3:8]))+
labs(title="American Jewish Population Estimates, 1776-1840",
     x = "Year",
     y = "Population")
attribution("Data: Jonathan Sarna, American Judaism")
dev.off()

# Population estimates late 19th century
# -------------------------------------------------------------------
png(filename = "jewish-population.late-19c.png",
    width=2000, height=2000, res=300)
ggplot(data[9:13,]) +
geom_line(aes(data$year[9:13], midpoint.population[9:13])) +
geom_errorbar(aes(
                  x=data$year[9:13],
                  ymin = midpoint.population[9:13] - error.population[9:13],
                  ymax = midpoint.population[9:13] + error.population[9:13]))+
labs(title="American Jewish Population Estimates, 1850-1900",
     x = "Year",
     y = "Population")
attribution("Data: Jonathan Sarna, American Judaism")
dev.off()


# Population percentage with error bars
# -------------------------------------------------------------------
png(filename = "jewish-population.percentage.png",
    width=2000, height=2000, res=300)
ggplot(data[3:23,]) +
geom_line(aes(data$year[3:23], midpoint.percentage[3:23])) +
geom_errorbar(aes(
                  x=data$year[3:23],
                  ymin = midpoint.percentage[3:23] - error.percentage[3:23],
                  ymax = midpoint.percentage[3:23] + error.percentage[3:23]))+
labs(title="Jewish Population as Percentage of All Americans, 1776-2000",
     x = "Year",
     y = "Population (percent)")
attribution("Data: Jonathan Sarna, American Judaism")
dev.off()
