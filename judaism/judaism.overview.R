# R script to chart demographic data on American Judaism

# Lincoln Mullen <lincoln@lincolnmullen.com>
# MIT License <http://lmullen.mit-license.org/> 

library(ggplot2)

makeFootnote <- function(footnoteText=
                         format(Sys.time(), "%d %b %Y"),
                         size= .7, color= grey(.5))
{
  require(grid)
  pushViewport(viewport())
  grid.text(label= footnoteText ,
            x = unit(1,"npc") - unit(2, "mm"),
            y= unit(2, "mm"),
            just=c("right", "bottom"),
            gp=gpar(cex= size, col=color))
  popViewport()
}

credit <- function() {
  return(makeFootnote("\nLincoln Mullen <http://lincolnmullen.com>"))
}

# Data
d <- read.csv("sarna.appendix.csv", comment.char = "#")

# Population estimates, 1660-2000
png( file="jews.1660-2000.ggplot.png" )
plot1 <- ggplot(d)
plot1 + 
geom_line(aes(d$year, d$estimate.low)) + 
geom_line(aes(d$year, d$estimate.high)) +
labs(title="American Jewish Population Estimates, 1660-2000", x = 
     "Year", y="Population")
makeFootnote("Data taken from Jonathan Sarna, American Judaism")
dev.off

# Population estimates, 1776-1900
png( file="jews.1776-1900.ggplot.png" )
plot2 <- ggplot(d[3:13,])
plot2 + 
geom_line(aes(d$year[3:13], d$estimate.low[3:13])) + 
geom_line(aes(d$year[3:13], d$estimate.high[3:13])) +
labs(title="American Jewish Population Estimates, 1776-1900", x = 
     "Year", y="Population")
makeFootnote("Data taken from Jonathan Sarna, American Judaism")
dev.off

# Population estimates with bars
# documentation: http://docs.ggplot2.org/0.9.3/geom_linerange.html
# I think I have to offer it the midpoint, plus and minus the distance
midpoint <- (d$estimate.high - d$estimate.low)/2 + d$estimate.low
error <- (d$estimate.high - d$estimate.low)/2
png(file="jews.1660-2000.errors.png", width = 900, height=900, 
    res=100, pointsize=9)
plot3 <- ggplot(d)
plot3 + 
geom_line(aes(d$year, midpoint)) +
geom_linerange(aes(x=d$year, ymin = midpoint - error, ymax = 
                   midpoint + error))+ 
labs(title="American Jewish Population Estimates, 1660-2000", x = 
     "Year", y="Population")
makeFootnote("Data taken from Jonathan Sarna, American Judaism")
dev.off
