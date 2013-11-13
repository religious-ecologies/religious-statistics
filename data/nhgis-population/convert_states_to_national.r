#!/usr/bin/Rscript --vanilla

# Convert populations of states into national population

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(plyr)
pop <- read.csv("nhgis0011_ts_state.csv")
pop$GISJOIN <- NULL
pop$STATEA <- NULL
pop$NAME <- NULL
colnames(pop) <- tolower(colnames(pop)) 
colnames(pop)[3] <- "population"
pop <- subset(pop, !is.na(population)) # drop troublesome NA
pop_national <- ddply(pop, "year", numcolwise(sum))
write.csv(pop_national, "census-population.csv", row.names = FALSE)
