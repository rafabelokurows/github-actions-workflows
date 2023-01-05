library(googletraffic)
library(ggplot2)
library(dplyr)
library(raster)

google_key <- Sys.getenv("DIRTYLITTLE")

rPorto <- gt_make_raster(location   = c(41.1579, -8.6291),
                    height     = 5000,
                    width      = 5000,
                    zoom       = 16,
                    google_key = google_key)
                    
rPorto_df <- rasterToPoints(rPorto, spatial = TRUE) %>% as.data.frame()                    
names(rPorto_df) <- c("value", "x", "y")

saveRDS(rPorto_df,paste0(Sys.time(),"_porto.rds"))
