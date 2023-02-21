# Github Actions and automating data collection using R

## Goals

1. Learn how to use Git Hub Actions - at least in a very basic sense - to start automating boring data collection tasks that I do in projects at work or for fun.
2. Start collecting data that could prove useful in the future for various reasons.

Therefore, I've created three diferent R scripts to scrape and process data from different sources with varying degrees of difficulty and for different uses.

## Roadmap

- [ ] Check fueleconomy.gov's API definition to see if there are other useful endpoints to call
- [ ] Start diving into the Google Traffic data to determine patterns
- [ ] Add Lidl to the store location scraper
- [ ] Add Auchan to the store location scraper
- [ ] Plot a map of store locations in relation to population density

## Data collection pipelines  

### Scraping US fuel prices

Origin: fuelconomy.gov  
Frequence: Daily  

[![Scraping US gas prices](https://github.com/rafabelokurows/scrapingActions/actions/workflows/main.yml/badge.svg)](https://github.com/rafabelokurows/scrapingActions/actions/workflows/main.yml)

### Scraping Google traffic data

Origin: Google Maps API  
Frequence: Three times per day  

[![Obtaining traffic data](https://github.com/rafabelokurows/scrapingActions/actions/workflows/main2.yml/badge.svg)](https://github.com/rafabelokurows/scrapingActions/actions/workflows/main2.yml)

### Scraping store locations from key retailers in Portugal

Origin: Each of the retailers' websites  
Frequence: Monthly

For now, I'm covering:
* Continente
* Pingo Doce
* Aldi
* Intermarché
* Minipreço (Dia %)

[![Scraping Portuguese retailers locations](https://github.com/rafabelokurows/scrapingActions/actions/workflows/main3.yml/badge.svg)](https://github.com/rafabelokurows/scrapingActions/actions/workflows/main3.yml)
