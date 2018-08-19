# make some weird species names

type <- c("marine", "terrestrial")

library(stringr)

sp_name_dat <- list()

for(ty in type){
  files <- dir(paste0("species_names/", ty), full.names=TRUE)

  sp_name_dat[[ty]] <- list()
  sp_name_dat[[ty]]$starts <- c()
  sp_name_dat[[ty]]$ends <- c()

  for(i in seq_along(files)){

    spp <- readLines(files[i])
    spp_split <- str_split(spp, "\\s+(?=\\S*+$)")

    spp_split <- lapply(spp_split, function(x) if(length(x)==1) c(x, "") else x)

    spp_final <- t(simplify2array(spp_split))

    sp_name_dat[[ty]]$starts <- c(sp_name_dat[[ty]]$starts, spp_final[,1])
    sp_name_dat[[ty]]$ends <- c(sp_name_dat[[ty]]$ends, spp_final[,2])
  }
}

save(sp_name_dat, file="sp_names.RData")
