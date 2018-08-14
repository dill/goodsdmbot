load_layers <- function (layercodes, equalarea = FALSE, rasterstack = TRUE,
    datadir = NULL)
{
    if (is.na(equalarea) || !is.logical(equalarea) || length(equalarea) !=
        1) {
        stop("equalarea should be TRUE or FALSE")
    }
    if (is.data.frame(layercodes)) {
        layercodes <- layercodes$layer_code
    }
    info <- get_layers_info(layercodes)
    counts <- table(info$common$time)
    if (length(unique(info$common$cellsize_equalarea)) > 1) {
        stop("Loading layers with different cellsize is not supported")
    }
    else if (sum(counts) != NROW(layercodes)) {
        layers <- info$common$layer_code
        stop(paste0("Following layer codes where not recognized: ",
            paste0(layercodes[!(layercodes %in% layers)], collapse = ", ")))
    }
    if (max(counts) != NROW(layercodes)) {
        warning("Layers from different eras (current, future, paleo) are being loaded together")
    }
    datadir <- get_datadir(datadir)
#    urlroot <- get_sysdata()$urldata
    get_layerpath <- function(layercode) {
        suffix <- ifelse(equalarea, "", "_lonlat")
        path <- paste0(datadir, "/", layercode, suffix, ".tif")
        if (!file.exists(path)) {
            url <- paste0(urlroot, layercode, suffix, ".tif")
            ok <- -1
            on.exit({
                if (ok != 0 && file.exists(path)) {
                  file.remove(path)
                }
            })
            ok <- utils::download.file(url, path, method = "auto",
                quiet = FALSE, mode = "wb")
        }
        ifelse(file.exists(path), path, NA)
    }
    paths <- sapply(layercodes, get_layerpath)
    if (rasterstack) {
        st <- raster::stack(paths)
        names(st) <- sub("_lonlat$", "", names(st))
        return(st)
    }
    else {
        return(lapply(paths, function(path) {
            r <- raster::raster(path)
            names(r) <- sub("_lonlat$", "", names(r))
            r
        }))
    }
}
