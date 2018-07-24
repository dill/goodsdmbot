###

library(viridis)
#set.seed(10)
library(sdmpredictors)
options(sdmpredictors_datadir="sdmdat")
datasets <- list_datasets(terrestrial = TRUE, marine =FALSE)

layers <- list_layers(datasets)

#layercodes <- layers$layer_code[c(21, 33, 45, 57, 69)]
#layercodes <- sample(layers$layer_code, 20)


layercodes <- layers$layer_code[3:68]

env <- load_layers(layercodes, equalarea = FALSE)
usa1 <- raster::crop(env, extent(-150, -60, 20, 55))

usa1 <- aggregate(usa1, fact=5)
#plot(usa1)


dat <- as.data.frame(usa1, xy=TRUE)
dat <- dat[!is.na(dat[,3]),]
xy <- dat[, 1:2]
#dat <- dat[, -(1:2)]

library(ggplot2)

for(i in seq_along(layercodes)){


  dat2 <- dat
  dat2$p <- dat2[,i]


  dat2$p <- dat2$p/sum(dat2$p)

  for(ct in c(0.9, 0.5, 0.3)){
    dat2 <- dat2[dat2$p < quantile(dat2$p, ct), ]

    rr <- range(dat2$p)
    if(nrow(dat2) > 50){
      for(wt in seq(0.3, 1, len=3)){
        dat2$pp <- wt*dat2$p
        # flip mode is the greatest
        for(flipmode in c(TRUE, FALSE)){

          if(flipmode){
          filler <- scale_fill_continuous(high="#41aaf2", low="#ffffff",
                                          na.value="white", limits=rr*sign(wt))
          }else{
          filler <- scale_fill_continuous(low="#41aaf2", high="#ffffff",
                                          na.value="white", limits=rr*sign(wt))
          }

          p <- ggplot(dat2) +
            geom_tile(aes(x=dat2$x, y=dat2$y, fill=pp)) +
            theme_void() + filler +
            lims(x=range(xy$x), y=range(xy$y)) +
            theme(legend.position = "none") +
            coord_equal()

          #print(p)
          ggsave(paste0("maps/env",i,"-",ct,"-",wt,".png"),
                 width=5, height=2.5, dpi=100,  bg = "transparent")
        }
      }
    }
  }
}

