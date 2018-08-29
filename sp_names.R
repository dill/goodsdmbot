# make some weird species names

type <- c("marine", "terrestrial")

library(stringr)
library(plyr)

sp_name_dat <- list()
probs <- list()

for(ty in type){
  files <- dir(paste0("species_names/", ty), full.names=TRUE)

  spp_df <- data.frame(name=NA, order=NA)
  probs[[ty]] <- c()

  for(i in seq_along(files)){

    spp <- readLines(files[i])

    # split up the names
    spp_split <- str_split(spp, "\\s")
    # empirically, what were the lengths
    probs[[ty]] <- c(probs[[ty]], laply(spp_split, length))

    lens <- laply(spp_split, length)
    lens <- unlist(lapply(lens, function(x) x:1))

    # attach the length, as the names and stack
    spp_df <- rbind(spp_df,
                    data.frame(name=unlist(spp_split),
                               order=lens))

  }
  spp_df <- spp_df[-1, ]
  sp_name_dat[[ty]] <- dlply(spp_df, .(order))
  probs[[ty]] <- table(probs[[ty]])
  probs[[ty]] <- probs[[ty]]/sum(probs[[ty]])
}

save(sp_name_dat, probs, file="sp_names.RData")
