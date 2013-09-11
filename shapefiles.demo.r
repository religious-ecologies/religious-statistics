#!/usr/bin/env Rscript --vanilla

# A demonstration of mapping historic U.S. state boundaries

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

library(R.utils)
library(ggmap)

states_1790 <- loadObject("data/clean/us.state.1790.low-res.Rdata")
states_1830 <- loadObject("data/clean/us.state.1830.low-res.Rdata")
states_1860 <- loadObject("data/clean/us.state.1860.low-res.Rdata")

center <- c(lon = -96.1, lat = 40)
map    <- qmap(center, zoom = 4)

# png(filename = "outputs/demo.state-boundaries.png",
#     width=11, height=8.5, units="in", res=300)
plot <- map + 
geom_polygon(data = states_1860, fill = 'blue', alpha = 0.4, color = 'gray',
             aes(x = long, y = lat, group = group)) +
geom_polygon(data = states_1830, fill = 'green', alpha = 0.4, color = 'gray',
             aes(x = long, y = lat, group = group)) +
geom_polygon(data = states_1790, fill = 'red', alpha = 0.4, color = 'gray',
             aes(x = long, y = lat, group = group)) +
ggtitle("The United States in 1790, 1830, and 1860") +
theme(legend.position = "none")
print(plot)
# dev.off()
