### setup SDM data

# David Lawrence Miller 2018

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


save(dat, xy, xlim, ylim, file="saved.RData")
