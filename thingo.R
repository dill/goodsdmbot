###

library(ggplot2)
library(mapdata)
library(viridis)

load("saved.RData")

generate_map <- function(dat, xy){
  datr <- as.matrix(dat) %*% 
            matrix(sample(rep(c(0,1),c(ncol(dat)-4,4)), ncol(dat))*
              runif(ncol(dat), -1, 1), ncol=1)
  dat$p <- datr[,1]
  dat$p <- dat$p - mean(dat$p)
  dat$p <- dat$p/max(dat$p)

  dat$p <- dat$p*sample(c(-1,1), 1)

  #dat$x <- xy[,1]
  #dat$y <- xy[,2]
  dat <- dat[dat$p>0, ]

  p <- ggplot(dat) +
    geom_tile(aes(x=x,y=y, fill=p)) +
    scale_fill_viridis() +
    borders("world", xlim = c(-130, -60), ylim = c(20, 50), colour="black")+
    theme_void() +
    coord_equal(xlim=xlim, ylim=ylim)

  ggsave(p, file="tmp.png")
}


generate_map(dat, xy)

