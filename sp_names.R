# make some weird species names

spp <- readLines("species_names.txt")
library(stringr)
spp_split <- str_split(spp, "\\s+(?=\\S*+$)")

spp_split <- lapply(spp_split, function(x) if(length(x)==1) c(x, "") else x)


spp_final <- t(simplify2array(spp_split))

starts <- spp_final[,1]
ends <- spp_final[,2]


save(starts, ends, file="sp_names.RData")
