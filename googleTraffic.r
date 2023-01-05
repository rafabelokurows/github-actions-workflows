library(googletraffic)
library(ggplot2)
library(dplyr)
library(raster)

google_key <- Sys.getenv("DIRTYLITTLE")

location   = c(41.1579, -8.6291)
height     = 5000
width      = 5000
zoom       = 16

rPorto = googleway::google_map(key = google_key, location = location, 
                      zoom = zoom, height = height, width = width, styles = style, 
                      zoom_control = FALSE, map_type_control = FALSE, scale_control = FALSE, 
                      fullscreen_control = FALSE, rotate_control = FALSE, 
                      street_view_control = FALSE) %>% googleway::add_traffic()

location   = c(38.722197, -9.139671)
height     = 5000
width      = 5000
zoom       = 16

rLisboa = googleway::google_map(key = google_key, location = location, 
                      zoom = zoom, height = height, width = width, styles = style, 
                      zoom_control = FALSE, map_type_control = FALSE, scale_control = FALSE, 
                      fullscreen_control = FALSE, rotate_control = FALSE, 
                      street_view_control = FALSE) %>% googleway::add_traffic()

# rPorto <- gt_make_raster(location   = c(41.1579, -8.6291),
#                     height     = 5000,
#                     width      = 5000,
#                     zoom       = 16,
#                     google_key = google_key)
                    
# rPorto_df <- rasterToPoints(rPorto, spatial = TRUE) %>% as.data.frame()                    
# names(rPorto_df) <- c("value", "x", "y")

saveRDS(rPorto,paste0("data/",Sys.time(),"_porto.rds"))
saveRDS(rLisboa,paste0("data/",Sys.time(),"_lisboa.rds"))
