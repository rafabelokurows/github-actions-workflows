library(dplyr)
library(rjson)
library(jsonlite)
library(RCurl)
library(httr)
library(reshape2)
library(tidyjson)
library(rlist)
library(rvest)

#### Pingo Doce ####
json = httr::GET('https://www.pingodoce.pt/wp-content/themes/pingodoce/ajax/pd-ajax.php?action=pd_stores_get_stores',
          accept_json())
content = content(json, type="application/json")
pingoDoceStores = list.stack(list.select(content$data$stores,id,name,lat,long,county,district,address,postal_code,
                                         directions_url,in_maintenance,contact,gas$gas_95,gas$gas_98,gas$diesel)) %>% as.data.frame()
pingoDoceStores = pingoDoceStores %>% mutate(across(c(id,lat,long,V1,V2,V3),as.numeric)) %>%
  rename(gas95 = V1,
         gas98 = V2,
         diesel = V3)
print(paste0("Pingo Doce: ",nrow(pingoDoceStores)))
write.csv(pingoDoceStores,paste0("data/stores/",format(Sys.Date(), "%Y%m%d"),"_PingoDoce.csv"),row.names = F)

#### Continente ####
urlConti = "https://uberall.com/api/storefinders/yw1Z9mcwR18Z5wPB8NSjLFyHhvPAMc/locations/all?v=20211005&language=pt&fieldMask=id&fieldMask=identifier&fieldMask=googlePlaceId&fieldMask=lat&fieldMask=lng&fieldMask=name&fieldMask=country&fieldMask=city&fieldMask=province&fieldMask=streetAndNumber&fieldMask=zip&fieldMask=businessId&fieldMask=addressExtra&"
json = httr::GET(urlConti,accept_json())
content = content(json, type="application/json")

continenteStores = list.stack(list.select(content$response$locations,id,identifier,googlePlaceId,lat,lng,
                                          name,
                                          country,
                                          city,
                                          province,
                                          streetAndNumber,
                                          zip,
                                          businessId,
                                          addressExtra)) %>% as.data.frame()
print(paste0("Continente: ",nrow(continenteStores)))
write.csv(continenteStores,paste0("data/stores/",format(Sys.Date(), "%Y%m%d"),"_Continente.csv"),row.names = F)

#### MERCADONA - ES e PT ####
urlMercadona =  "https://www.mercadona.com/estaticos/cargas/data.js?timestamp=%271654860909332%27"
json = httr::GET(urlMercadona,accept_json())
content = content(json, type="text")

badComma = stringi::stri_locate_last_fixed(content, ",")[,1]
json2 = paste(substr(content,15,(badComma-1)), substr(content,(badComma+1),(nchar(content)-1)))

mercadonaStores = jsonlite::fromJSON(json2)$tiendasFull %>% as.data.frame()%>%
  rename(country = p,
         district = pv,
         county = lc,
         address = dr,
         postalCode = cp,
         phone= tf,
         lat = lt,
         long = lg)
print(paste0("Mercadona: ",nrow(mercadonaStores)))
write.csv(mercadonaStores,paste0("data/stores/",format(Sys.Date(), "%Y%m%d"),"_Mercadona.csv"),row.names = F)

#### LIDL ####
#Precisa obter uma key, mas a query continua a mesma (ver POSTMAN)
# urlLidl = "https://spatial.virtualearth.net/REST/v1/data/e470ca5678c5440aad7eecf431ff461a/Filialdaten-PT/Filialdaten-PT?$select=*,__Distance&$filter=Adresstyp%20eq%201&key=AnbU6jHbo3W8nPXLpLvZGLz2cgajICoIt8OA9wqML8FLKXHZozV0pHye2JOR5UgG&$format=json&jsonp=Microsoft_Maps_Network_QueryAPI_2&spatialFilter=bbox(36.94,-9.67,42.11,-6.68)&$top=300"
# json = httr::GET(urlLidl,accept_json())
# content = content(json, type="text")
# jsonLidl = substr(content,35,(nchar(content)-1))
# lidlStores = jsonlite::fromJSON(jsonLidl)$d$results %>% as.data.frame()
# lidlStores = lidlStores %>% select(EntityID,ShownStoreName,CountryRegion,PostalCode,Locality,AddressLine,OpeningTimes,
#                       Latitude,Longitude,AR,NF,INFOICON1:INFOICON31)
# write.csv(lidlStores,paste0(format(Sys.Date(), "%Y%m%d"),"Lidl.csv"))

#### ALDI ####
urlAldi = "https://uberall.com/api/storefinders/ALDINORDPT_YTvsWfhEG5TCPruM6ab6sZIi0Xodyx/locations/all?v=20211005&language=pt&fieldMask=id&fieldMask=identifier&fieldMask=googlePlaceId&fieldMask=lat&fieldMask=lng&fieldMask=name&fieldMask=country&fieldMask=city&fieldMask=province&fieldMask=streetAndNumber&fieldMask=zip&fieldMask=businessId&fieldMask=addressExtra&"
json = httr::GET(urlAldi,accept_json())
content = content(json, type="text")


aldiStores = jsonlite::fromJSON(content)$response$locations %>% as.data.frame()
print(paste0("Aldi: ",nrow(aldiStores)))
write.csv(aldiStores,paste0("data/stores/",format(Sys.Date(), "%Y%m%d"),"_Aldi.csv"),row.names = F)
#### Minipreço ####
url = "https://clube.minipreco.pt/PT/tiendas.v639.json.gz"
download.file(url,"minipreco.gz")
gz = gzfile("minipreco.gz")
minipreco = jsonlite::fromJSON(gz)
print(paste0("Minipreço: ",nrow(minipreco)))
write.csv(minipreco,paste0("data/stores/",format(Sys.Date(), "%Y%m%d"),"_DiaMiniPreco.csv"),row.names = F)

#### Intermarché ####
urlIntermarche = "https://www.intermarche.pt/lojas/"
pageIntermarche = read_html(urlIntermarche)
teste = pageIntermarche %>%
  html_nodes("#poss-district") %>%
  html_nodes("li") %>%
  html_children

ids = lapply(teste, function(x) x %>% html_children %>% html_attr("data-id"))
lats = lapply(teste, function(x) x %>% html_children %>% html_attr("data-latitude"))
longs = lapply(teste, function(x) x %>% html_children %>% html_attr("data-longitude"))
title = lapply(teste, function(x) x %>% html_children %>% html_attr("data-title"))
urls = lapply(teste, function(x) x %>% html_children %>% html_attr("data-url"))
links = lapply(teste, function(x) x %>% html_children %>% html_attr("href"))
av = lapply(teste, function(x) x %>% html_children %>% html_attr("data-av"))
ap = lapply(teste, function(x) x %>% html_children %>% html_attr("data-ap"))
pa = lapply(teste, function(x) x %>% html_children %>% html_attr("data-pa"))
es = lapply(teste, function(x) x %>% html_children %>% html_attr("data-es"))
label = lapply(teste, function(x) x %>% html_children %>% html_attr("data-ga-label"))

intermarcheStores = bind_cols(nome = label %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
id = ids %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
cidade = title %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
url = urls %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
av = av %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
ap = ap %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
pa = pa %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
es  =es %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
lat = lats %>% unlist(use.names = F) %>% purrr::discard(is.na(.)),
long  = longs %>% unlist(use.names = F) %>% purrr::discard(is.na(.))
) %>% as.data.frame()

df=data.frame()
for (i in 1:nrow(intermarcheStores)){
  print(i)
  url = intermarcheStores[i,"url"]

  page = read_html(url)
  nome = html_text(html_nodes(page,".name"))%>% gsub("[\t\n\r]", "", .) %>% trimws()
  endereco = html_text(html_nodes(page,".streetAddress")) %>% gsub("[\t\n\r]", "", .) %>% trimws()
  localidade = html_text(html_nodes(page,".addressLocality")) %>% gsub("[\t\n\r]", "", .) %>% trimws()
  cp = html_text(html_nodes(page,".postalCode")) %>% gsub("[\t\n\r]", "", .) %>% trimws()
  email = html_nodes(page,".email") %>% html_attr("content") %>% purrr::discard(is.na(.))
  time = html_text(html_nodes(page,".time")) %>% gsub("[\t\n\r]", "", .) %>% trimws()  %>% paste0(.,sep=" - ",collapse="")
  fone = html_text(html_nodes(page,".telephone")) %>% gsub("[\t\n\r]", "", .) %>% trimws()
  recolhas = html_text(html_nodes(page,".recolhas")) %>% gsub("[\t\n\r]", "", .) %>% trimws()

  nova = data.frame(nome,
                    endereco,
                    localidade = ifelse(identical(localidade, character(0)),NA,localidade),
                    cp,
                    email = ifelse(identical(email, character(0)),NA,email),

                    time = ifelse(identical(time, character(0)),NA,time),
                    fone = ifelse(identical(fone, character(0)),NA,fone),
                    recolhas = ifelse(identical(recolhas, character(0)),FALSE,TRUE))

  print(nova)
  df=bind_rows(df,nova)
}
intermarcheStores = intermarcheStores %>%
  mutate(nomeAux = paste0("Intermarché ",cidade,sep="")) %>% left_join(df,by=c("nomeAux"= "nome"))
print(paste0("Intermarché: ",nrow(intermarcheStores)))
write.csv(intermarcheStores,paste0("data/stores/",format(Sys.Date(), "%Y%m%d"),"_InterMarche.csv"),row.names = F)


#### Resumo ####
df = data.frame(retailer=c("Pingo Doce",
                      "Continente",
                      "Mercadona",
                      "Lidl",
                      "Aldi",
                      "Minipreço",
                      "Intermarche"),lojas = c(dim(pingoDoceStores)[1],
                                             dim(continenteStores)[1],
                                             dim(mercadonaStores %>% filter(country=="PT"))[1],
                                             0,
                                             dim(aldiStores)[1],
                                             dim(minipreco)[1],
                                             dim(intermarcheStores)[1]
                      ),
           data=Sys.Date())
print(df)
write.csv(df,paste0("data/stores/",format(Sys.Date(), "%Y%m%d"),"_resumo.csv"),row.names = F)
