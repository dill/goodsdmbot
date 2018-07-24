# get dropbox links


library(rdrop2)
drop_auth()

env_list <- dir("~/Dropbox/mappy/")
urls <- rep(NA, length(env_list))

ii <- 1
for(i in env_list){
  ds <- try(drop_share(paste0("/mappy/", i)))

  if(class(ds) != "try-error"){
    urls[ii] <- ds$url
  }
  ii <- ii + 1
}


urls <- urls[!is.na(urls)]

envs <- sub("dl=0", "raw=1", urls)

aa <- paste0("\"envs\" :", "[\"",
             paste0(envs, collapse="\", \""),
             "\"],")
cat(aa)
