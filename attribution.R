# R functions to provide attribution

# This file is should be sourced by other files in the project. I've 
# borrowed the code from Kieran Healy: 
# https://github.com/kjhealy/assault-deaths/blob/master/assault-2010.r

attribution <- function(footnoteText = format(Sys.time(), "%d %b %Y"),
                        size= .7, 
                        color= grey(.5)) {
  require(grid)
  pushViewport(viewport())
  grid.text(label= footnoteText ,
            x = unit(1,"npc") - unit(2, "mm"),
            y= unit(2, "mm"),
            just=c("right", "bottom"),
            gp=gpar(cex= size, col=color))
  popViewport()
}
