library(httr)
library(jsonlite)
library(dplyr)

raw_data <- httr::GET("https://www.fueleconomy.gov/ws/rest/fuelprices")

api_char = rawToChar(raw_data$content)
api_json = jsonlite::fromJSON(api_char,simplifyDataFrame = T)

df = api_json %>% as.data.frame() %>% mutate(time=Sys.time(),.before = everything())

write.csv(df,paste0("data/fuel/",Sys.Date(),"_fuel_prices.csv"),row.names = F)
