# USAUSAUSA

library(ggplot2)
library(mapdata)

pp <- ggplot() +
        borders("world", xlim = c(-130, -60), ylim = c(20, 50), colour="black")+
        theme_void()

xlim <- c(-133.54167, -60.20833)
ylim <- c(20.20833, 54.79167)

ppp <- pp + coord_equal(xlim=xlim, ylim=ylim)

ggsave(ppp, file="usa.png", width=5, height=2.5, dpi=100,  bg = "transparent")



