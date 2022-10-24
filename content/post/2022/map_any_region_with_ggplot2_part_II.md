---
author: "M. Teodoro Tenango"
title: "Map any region in the world with R - Part II: Obtaining the coordinates"
image: ""
draft: true
date: 2022-10-24
description: "Part II of making maps of any region in the world with R using ggplot2 and maps packages"
tags: ["R maps", "ggplot2", "Code Visuals", "R functions"]
categories: ["R"]
archives: ["2022"]
---

## Scope of this post

This is the second part of the series of post to create a map of any region of the world with R.

We are creating maps of data showing changes over a span of time for different countries and pointing at all kinds of cities. That basically means that we need to **map any region of the world with R**. Today there are all kinds of packages and techniques to do that. I will share the strategy I used with [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html) and [maps](https://cran.r-project.org/web/packages/maps/index.html) packages, using support of [Open Street Map](https://www.openstreetmap.org/) to obtain the coordinates of cities and finally making it interactive with [shiny](https://shiny.rstudio.com/). The project is quite long for a single post, so my idea is to split it into a few smaller blog posts. So far, the list is a follows:

1. [The basic map](https://blog.rwhitedwarf.com/post/map_any_region_with_ggplot2_part_i/)
2. **Web scrapping with nominatim open street maps**
3. Maps with cities
4. Dynamic maps in time
5. Making a single script for fast replication
6. Making the code interactive in a shiny app
	
It is my way to share the how-to of one of the projects I am most proud of, and at the same time to give back to the R community in hopes that it can help somebody else.

I hope you all enjoy it. Feel free to leave any kind of comment and/or question at the end.

# Open Street Maps and Nominatim

> A simple query
> 
> ```r
> library('RJSONIO')
> 
> site <- ("http://nominatim.openstreetmap.org/search?city=Texcoco&limit=9&format=json")
> (result <- fromJSON(site))
> ```
> 
> ```
> > [[1]]
> > [[1]]$place_id
> > [1] 1177116
> > 
> > [[1]]$licence
> > [1] "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright"
> > 
> > [[1]]$osm_type
> > [1] "node"
> > 
> > [[1]]$osm_id
> > [1] 336169214
> > 
> > [[1]]$boundingbox
> > [1] "29.619"       "29.659"       "-111.0786667" "-111.0386667"
> > 
> > [[1]]$lat
> > [1] "29.639"
> > 
> > [[1]]$lon
> > [1] "-111.0586667"
> > 
> > [[1]]$display_name
> > [1] "Texcoco, Carbó, Sonora, México"
> > 
> > [[1]]$class
> > [1] "place"
> > 
> > [[1]]$type
> > [1] "village"
> > 
> > [[1]]$importance
> > [1] 0.385
> > 
> > [[1]]$icon
> > [1] "https://nominatim.openstreetmap.org/ui/mapicons/poi_place_village.p.20.png"
> > 
> > 
> > [[2]]
> > [[2]]$place_id
> > [1] 3448536
> > 
> > [[2]]$licence
> > [1] "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright"
> > 
> > [[2]]$osm_type
> > [1] "node"
> > 
> > [[2]]$osm_id
> > [1] 458633446
> > 
> > [[2]]$boundingbox
> > [1] "16.551667"  "16.591667"  "-97.053333" "-97.013333"
> > 
> > [[2]]$lat
> > [1] "16.571667"
> > 
> > [[2]]$lon
> > [1] "-97.033333"
> > 
> > [[2]]$display_name
> > [1] "Texcoco, Santa María Sola, Oaxaca, México"
> > 
> > [[2]]$class
> > [1] "place"
> > 
> > [[2]]$type
> > [1] "hamlet"
> > 
> > [[2]]$importance
> > [1] 0.36
> > 
> > [[2]]$icon
> > [1] "https://nominatim.openstreetmap.org/ui/mapicons/poi_place_village.p.20.png"
> ```

We start with [Open Street Map](https://www.openstreetmap.org/) and its API nominatim.


```r
city <- 'San%20Francisco'
state <- '&state=California'
country <- '&countrycodes=US'
start.nominatim <- "http://nominatim.openstreetmap.org/search?city="
end.nominatim <- "&limit=9&format=json"

site <- paste0(start.nominatim, city, country, state, end.nominatim)
(result <- fromJSON(site))
```

```
> [[1]]
> [[1]]$place_id
> [1] 297054975
> 
> [[1]]$licence
> [1] "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright"
> 
> [[1]]$osm_type
> [1] "relation"
> 
> [[1]]$osm_id
> [1] 111968
> 
> [[1]]$boundingbox
> [1] "37.6403143"  "37.929811"   "-123.173825" "-122.281479"
> 
> [[1]]$lat
> [1] "37.7790262"
> 
> [[1]]$lon
> [1] "-122.419906"
> 
> [[1]]$display_name
> [1] "San Francisco, CAL Fire Northern Region, California, United States"
> 
> [[1]]$class
> [1] "boundary"
> 
> [[1]]$type
> [1] "administrative"
> 
> [[1]]$importance
> [1] 1.035131
> 
> [[1]]$icon
> [1] "https://nominatim.openstreetmap.org/ui/mapicons/poi_boundary_administrative.p.20.png"
```

The final form of the function


```r
coords_from_city <- function(City,
                             CountryTwoLetter,
                             Region = NULL,
                             State = NULL,
                             County = NULL){
    require('RJSONIO')
    CityCoded <- gsub(' ','%20',City) #remove space for URLs
    CountryCoded <- paste("&countrycodes=", CountryTwoLetter, sep = '')
    if(!missing(State)){
        State <- paste("&state=", gsub(' ','%20',State), sep = '')
    }
    if(!missing(County)){
        County <- paste("&county=", gsub(' ','%20',County), sep = '')
    }
    if(!missing(Region)){
        Region <- paste("&region=", gsub(' ','%20',Region), sep = '')
    }
    ## get data
    url <- paste(
        "http://nominatim.openstreetmap.org/search?city="
      , CityCoded
      , CountryCoded
      , State
      , County
      , Region
      , "&limit=9&format=json"
      , sep="")
    x <- fromJSON(url)
    ## retrieve coords
    if(is.vector(x)){
            message(paste('Found', x[[1]]$display_name))
            lon <- x[[1]]$lon
            lat <- x[[1]]$lat
            osm_name <- x[[1]]$display_name
            coords <- data.frame('lon' = lon, 'lat' = lat, 'osm_name' = osm_name)
    }
    ## When x is not a vector
    else{
        message(paste('No results found for', City, CountryTwoLetter))
        coords <- data.frame('lon' = NA, 'lat' = NA)
    }
    ## return a df
    coords
}
```

# Keeping the info in a database



```r
webscrap_to_sqlite <- function(db.name,
                               dat,
                               city = 'City',
                               country = 'Country',
                               region = NULL,
                               state = NULL,
                               county = NULL)
{
    require(tidyverse)
    require(RSQLite)
    df_len <- length(dat[[city]])
    ## Connect to db and table
    con <- dbConnect(drv=RSQLite::SQLite(), dbname=db.name)
    dbExecute(conn = con,
                "CREATE TABLE IF NOT EXISTS orgs
                    (ID INTEGER UNIQUE,
                     City TEXT, osm_name TEXT,
                     lon REAL,lat REAL)")
    ## -- Iteration to web-scrap data -- ##
    ccount <- 0
    ## For loop to webscrapping
    for(i in 1:df_len){
        print(paste('Entry', i))
        ## Check if the city details are already there
        searched.city <- dbGetQuery(conn = con,
                                    paste0("SELECT * FROM orgs WHERE City = '",
                                           dat[[city]][i],
                                           "' LIMIT 1"))
        ## If so, get them
        if(nrow(searched.city) != 0){
            message(paste0(dat[[city]][i], " already in DB!"))
            coords <- data.frame(osm_name = searched.city$osm_name,
                                 lon = searched.city$lon,
                                 lat = searched.city$lat)
        }
        ## Else, do the webscrap
        else{
            ## Else
            if(missing(region) & missing(county) & missing(state)){
                coords <- coords_from_city(dat[[city]][i],
                                           dat[[country]][i])
            }
            if(!missing(region)){
                coords <- coords_from_city(dat[[city]][i],
                                           dat[[country]][i],
                                           Region = dat[[region]][i])
            }
            if(!missing(state)){
                coords <- coords_from_city(dat[[city]][i],
                                           dat[[country]][i],
                                           State = dat[[state]][i])
            }
            if(!missing(county)){
                coords <- coords_from_city(dat[[city]][i],
                                           dat[[country]][i],
                                           County = dat[[county]][i])
            }
            if(!missing(county) & !missing(state)){
                coords <- coords_from_city(dat[[city]][i],
                                           dat[[country]][i],
                                           State = dat[[state]][i],
                                           County = dat[[county]][i])
            }
        }
        ## DB send query ONLY if coords were found
        if(is.na(coords$lon[1])){
            ccount <- ccount + 1
        }
        else{
            sq <- dbExecute(con, 'INSERT OR IGNORE INTO orgs
                             (ID, City, osm_name, lon, lat)
                             VALUES (?, ?, ?, ?, ?);',
                        list(dat[['ID']][i], dat[[city]][i],
                             coords$osm_name, coords$lon[1], coords$lat[1]))
        }
        print(paste('Completed', (i/df_len)*100, '%'))
    }
    ## Close db
    dbDisconnect(con)
    message(paste("WEB SCRAP FOR COORDINATES SEARCH FINISHED.",
                ccount, "ENTRIES NOT FOUND"))
}
```

# Missing data



```r
compare_db_data <- function(db.file, dat){
    require(tidyverse)
    require(RSQLite)
    if(is.character(dat)){
        if(grepl('.csv', dat, fixed = T)){
            tib <- read_csv(dat)
        }
        else{
            stop("Incorrect file format for data")
        }
    }
    else if(is.data.frame(dat)){
        tib <- dat
    }
    else{
        stop("Incorrect data format")
    }
    con <- dbConnect(drv=RSQLite::SQLite(), dbname = db.file)
    db <- as_tibble(dbReadTable(con, "orgs"))
    dbDisconnect(con)
    filtered <- filter(tib, !(as.character(ID) %in%
                              as.character(db$ID)))
    filtered
}
```



```r
add_coords_manually <- function(csv_file, db.name,
                                city, osm_name, lat, lon){
    require(tidyverse)
    require(RSQLite)
    csv_dat <- read_csv(csv_file)
    csv_len <- length(csv_dat$ID)
    con <- dbConnect(drv=RSQLite::SQLite(), dbname=db.name)
    for(i in 1:csv_len){
        dbSendQuery(con, 'INSERT OR IGNORE INTO orgs
                      (ID, City, osm_name, lon, lat)
                      VALUES (?, ?, ?, ?, ?);',
                    list(csv_dat[['ID']][i],
                         csv_dat[[city]][i],
                         csv_dat[[osm_name]][i],
                         csv_dat[[lat]][i],
                         csv_dat[[lon]][i]))
    }
    dbDisconnect(con)
    print(paste(csv_len, 'inserted'))
}
```
