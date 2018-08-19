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

# get terrestrial env
datasets <- list_datasets(terrestrial=TRUE, marine=FALSE)
layers <- list_layers(datasets)
layercodes <- layers$layer_code[1:68]
env[["terrestrial"]] <- load_layers(layercodes, equalarea = FALSE)
# get marine env
datasets <- list_datasets(terrestrial=FALSE, marine=TRUE)
layers <- list_layers(datasets)
layercodes <- layers$layer_code[1:26]
env[["marine"]] <- load_layers(layercodes, equalarea = FALSE)


get_dat <- function(spec, env){

  e <- spec$extent
  this_env <- env[[spec$type]]
  env_crop <- raster::crop(this_env, extent(e[1], e[2], e[3], e[4]))

  env_crop <- aggregate(env_crop, fact=5)


  dat <- as.data.frame(env_crop, xy=TRUE)
  dat <- dat[!is.na(dat[,3]),]
  xy <- dat[, 1:2]
  dat <- dat[, -(1:2)]


  dat <- apply(dat, 2, function(x) (x-mean(x))/sd(x))
  dat <- as.data.frame(dat)


  dat <- cbind(xy, dat)

  return(dat)
}



# make a list of regions
spec <- list()

# each element of spec is a list with the following elements
#  extent        - the bounding box for the area
#  type          - environment type (marine or terrestrial)
#  dat           - the data.frame of environmental data within extent
#  pos           - where to position the species name on the plot

# west coast US
spec[[1]] <- list()
spec[[1]]$extent <- c(-130, -105, 15, 50)
spec[[1]]$type <- "marine"
spec[[1]]$dat <- get_dat(spec[[1]], env)
spec[[1]]$pos <- "bottomleft"

# North America
spec[[2]] <- list()
spec[[2]]$extent <- c(-133.54167, -60.20833, 20.20833, 54.79167)
spec[[2]]$type <- "terrestrial"
spec[[2]]$dat <- get_dat(spec[[2]], env)
spec[[2]]$pos <- "bottomleft"

# east coast US w/ GoM
spec[[3]] <- list()
spec[[3]]$extent <- c(-100, -70, 15, 45)
spec[[3]]$type <- "marine"
spec[[3]]$dat <- get_dat(spec[[3]], env)
spec[[3]]$pos <- "topleft"

# Australia
# this doesn't work because of some raster bullshit?
#spec[[XX]] <- list()
#spec[[XX]]$extent <- c(110, 155, -XX5, -7)
#spec[[XX]]$type <- "terrestrial"
#spec[[XX]]$dat <- get_dat(spec[[XX]], env)
#spec[[XX]]$pos <- "topleft"

XX <- 4
# coastal Australia
spec[[XX]] <- list()
spec[[XX]]$extent <- c(110, 155, -45, -7)
spec[[XX]]$type <- "marine"
spec[[XX]]$dat <- get_dat(spec[[XX]], env)
spec[[XX]]$pos <- "bottomleft"
XX <- XX+1

# Africa
# this doesn't work because of some raster bullshit?
#spec[[XX]] <- list()
#spec[[XX]]$extent <- c(-20, 60, -40, 40)
#spec[[XX]]$type <- "terrestrial"
#spec[[XX]]$dat <- get_dat(spec[[XX]], env)
#spec[[XX]]$pos <- "bottomleft"
#XX <- XX+1

# coastal Africa
spec[[XX]] <- list()
spec[[XX]]$extent <- c(-20, 60, -40, 40)
spec[[XX]]$type <- "marine"
spec[[XX]]$dat <- get_dat(spec[[XX]], env)
spec[[XX]]$pos <- "bottomleft"
XX <- XX+1

# Euro waters
spec[[XX]] <- list()
spec[[XX]]$extent <- c(-30, 45, 30, 65)
spec[[XX]]$type <- "marine"
spec[[XX]]$dat <- get_dat(spec[[XX]], env)
spec[[XX]]$pos <- "bottomleft"
XX <- XX+1

# Euro land
spec[[XX]] <- list()
spec[[XX]]$extent <- c(-30, 45, 30, 65)
spec[[XX]]$type <- "terrestrial"
spec[[XX]]$dat <- get_dat(spec[[XX]], env)
spec[[XX]]$pos <- "bottomleft"
XX <- XX+1

# Indian ocean
spec[[XX]] <- list()
spec[[XX]]$extent <- c(45, 110, -30, 23)
spec[[XX]]$type <- "marine"
spec[[XX]]$dat <- get_dat(spec[[XX]], env)
spec[[XX]]$pos <- "bottomleft"
XX <- XX+1



save(spec, file="saved.RData")
