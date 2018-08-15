### setup SDM data

# David Lawrence Miller 2018

library(ggplot2)
library(mapdata)
library(viridis)
#set.seed(10)
library(sdmpredictors)
options(sdmpredictors_datadir="sdmdat")


# grab some layers
env <- list()
inds <- list(1:45, 1:68)
for(marine in c(TRUE, FALSE)){
  datasets <- list_datasets(terrestrial=!marine, marine=marine)
  layers <- list_layers(datasets)
  layercodes <- layers$layer_code[inds[[marine+1]]]
  env[[marine+1]] <- load_layers(layercodes, equalarea = FALSE)
}

get_dat <- function(spec, env){

  e <- spec$extent
  this_env <- env[[spec$marine+1]]
  env_crop <- raster::crop(this_env, extent(e[1], e[2], e[3], e[4]))

  env_crop <- aggregate(env_crop, fact=5)


  dat <- as.data.frame(env_crop, xy=TRUE)
  dat <- dat[!is.na(dat[,3]),]
  xy <- dat[, 1:2]
  dat <- dat[, -(1:2)]


  dat <- apply(dat, 2, function(x) (x-mean(x))/sd(x))
  dat <- as.data.frame(dat)


  dat <- cbind(xy, dat)

  return(list(data=dat,
              xlim=e[1:2],
              ylim=e[3:4]))
}



# make a list of regions
spec <- list()

spec[[1]] <- list()
spec[[1]]$extent <- c(-150, -60, 20, 55)
spec[[1]]$marine <- FALSE

spec[[2]] <- list()
spec[[2]]$extent <- c(-133.54167, -60.20833, 20.20833, 54.79167)
spec[[2]]$marine <- FALSE

dd <- get_dat(spec[[1]], env)


dat <- dd$dat
xlim <- dd$xlim
ylim <- dd$ylim

save(dat, xlim, ylim, file="saved.RData")
