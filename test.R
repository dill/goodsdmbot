###

library(ggplot2)
library(mapdata)
library(viridis)
#set.seed(10)
library(sdmpredictors)
options(sdmpredictors_datadir="sdmdat")
source("load_layers_offline.R")
datasets <- list_datasets(terrestrial = TRUE, marine =FALSE)

layers <- list_layers(datasets)

layercodes <- layers$layer_code[1:68]


env <- load_layers(layercodes, equalarea = FALSE)
usa1 <- raster::crop(env, extent(-150, -60, 20, 55))

usa1 <- aggregate(usa1, fact=5)
#plot(usa1)


dat <- as.data.frame(usa1, xy=TRUE)
dat <- dat[!is.na(dat[,3]),]
xy <- dat[, 1:2]
dat <- dat[, -(1:2)]


dat <- apply(dat, 2, function(x) (x-mean(x))/sd(x))
dat <- as.data.frame(dat)

xlim <- c(-133.54167, -60.20833)
ylim <- c(20.20833, 54.79167)

dat <- cbind(xy, dat)

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

  return(p)
}


generate_map(dat, xy)

