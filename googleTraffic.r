library(googleway)
library(htmlwidgets)
library(ggplot2)
library(dplyr)
#library(raster)

google_key <- Sys.getenv("DIRTYLITTLE")

webshot_delay = 5
style <- "[\n    {\n        \"elementType\": \"labels\",\n        \"stylers\": [\n            {\n                \"visibility\": \"off\"\n            }\n        ]\n    },\n    {\n        \"elementType\": \"geometry\",\n        \"stylers\": [\n            {\n                \"visibility\": \"off\"\n            }\n        ]\n    },\n    {\n        \"featureType\": \"road\",\n        \"elementType\": \"geometry\",\n        \"stylers\": [\n            {\n                \"visibility\": \"on\"\n            },\n            {\n                \"color\": \"#ffffff\"\n            }\n        ]\n    },\n    {\n        \"featureType\": \"landscape\",\n        \"stylers\": [\n            {\n                \"color\": \"#ffffff\"\n            },\n            {\n                \"visibility\": \"on\"\n            }\n        ]\n    },\n    {}\n]"
location   = c(41.1579, -8.6291)
height     = 5000
width      = 5000
zoom       = 16

rPorto = googleway::google_map(key = google_key, location = location, 
                      zoom = zoom, height = height, width = width, styles = style, 
                      zoom_control = FALSE, map_type_control = FALSE, scale_control = FALSE, 
                      fullscreen_control = FALSE, rotate_control = FALSE, 
                      street_view_control = FALSE) %>% googleway::add_traffic()
htmlwidgets::saveWidget(rPorto, paste0("data/traffic/",Sys.time(),"_porto.html"), selfcontained = TRUE)

location   = c(38.722197, -9.139671)
height     = 5000
width      = 5000
zoom       = 16

rLisboa = googleway::google_map(key = google_key, location = location, 
                      zoom = zoom, height = height, width = width, styles = style, 
                      zoom_control = FALSE, map_type_control = FALSE, scale_control = FALSE, 
                      fullscreen_control = FALSE, rotate_control = FALSE, 
                      street_view_control = FALSE) %>% googleway::add_traffic()
htmlwidgets::saveWidget(rLisboa, paste0("data/traffic/",Sys.time(),"_lisboa.html"), selfcontained = TRUE)
# rPorto <- gt_make_raster(location   = c(41.1579, -8.6291),
#                     height     = 5000,
#                     width      = 5000,
#                     zoom       = 16,
#                     google_key = google_key)
                    
# rPorto_df <- rasterToPoints(rPorto, spatial = TRUE) %>% as.data.frame()                    
# names(rPorto_df) <- c("value", "x", "y")

saveRDS(rPorto,paste0("data/traffic/",Sys.time(),"_porto.rds"))
saveRDS(rLisboa,paste0("data/traffic/",Sys.time(),"_lisboa.rds"))
