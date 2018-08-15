### post some excellent SDMs to the popular microblogging
###  platform twitter dot com

# David Lawrence Miller 2018

setwd("~/sdmbot")
library(ggplot2)
library(mapdata)
library(viridis)

load("saved.RData")
load("sp_names.RData")

generate_map <- function(dat, xy){
  datr <- as.matrix(dat) %*%
            matrix(sample(rep(c(0, 1), c(ncol(dat)-4, 4)), ncol(dat))*
              runif(ncol(dat), -1, 1), ncol=1)
  dat$p <- datr[,1]
  dat$p <- dat$p - mean(dat$p)
  dat$p <- dat$p/max(dat$p)

  dat$p <- dat$p*sample(c(-1,1), 1)

  dat <- dat[dat$p>0, ]

  p <- ggplot(dat) +
    geom_tile(aes(x=x,y=y, fill=p)) +
    scale_fill_viridis() +
    borders("world", xlim = c(-130, -60), ylim = c(20, 50), colour="black")+
    theme_void() +
    annotate("text", x=-133, y=21, hjust="left",
             label=paste(sample(starts, 1), sample(ends, 1))) +
    coord_equal(xlim=xlim, ylim=ylim)

  fn <- paste0("sdm", gsub(" ", "-", date()), ".png")
  ggsave(p, file=fn, width=7, height=3)
  return(fn)
}

post_it <- function(fn){
  # how to from here:
  # https://github.com/twitter/twurl/issues/58
  fuzzy_dog <- system2("/usr/local/bin/twurl",
                  paste0("-H upload.twitter.com \"/1.1/media/upload.json\" -f ",
                         fn,
                         " -F media -X POST"), stdout=TRUE)

  fuzzy_dog <- sub(".*\"media_id\":(\\d+).*", "\\1", fuzzy_dog)
  cat(fuzzy_dog,"\n")
  fuzzy_dog2 <- system2("/usr/local/bin/twurl",
                        paste0("\"/1.1/statuses/update.json\" -d \"media_ids=",
                               fuzzy_dog,
                               "&status=\""))
}



fn <- generate_map(dat, xy)

#post_it(fn)




