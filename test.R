###

library(viridis)
#set.seed(10)
library(sdmpredictors)
options(sdmpredictors_datadir="sdmdat")
datasets <- list_datasets(terrestrial = TRUE, marine =FALSE)

layers <- list_layers(datasets)

layercodes <- layers$layer_code[c(1, 2, 21, 33, 45, 57, 69)]#, 89,
#                                  90, 92, 96, 267)]
 #sample(layers$layer_code, 4)



env <- load_layers(layercodes, equalarea = FALSE, datadir="sdmdat")
usa1 <- raster::crop(env, extent(-150, -60, 20, 55))

usa1 <- aggregate(usa1, fact=5)
#plot(usa1)


dat <- as.data.frame(usa1, xy=TRUE)
dat <- dat[!is.na(dat[,3]),]
xy <- dat[, 1:2]
dat <- dat[, -(1:2)]

library(ggplot2)

#dat$p <- as.matrix(dat) %*% matrix(rbinom(ncol(dat),1,0.4)*runif(ncol(dat), -1, 1), ncol=1)
dat$p <- as.matrix(dat) %*% matrix(rbinom(ncol(dat),1,0.4)*rnorm(ncol(dat)), ncol=1)
dat$p <- dat$p/max(dat$p)
dat$p <- dat$p - min(dat$p)

dat$x <- xy[,1]
dat$y <- xy[,2]
dat <- dat[dat$p>0.1, ]


p <- ggplot(dat) +
  geom_tile(aes(x=x,y=y, fill=p)) +
  scale_fill_viridis() +
  coord_equal()

#print(p)

ggsave(p, file="tmp.png", width=800, units="px")

