---
author: "Manuel Teodoro Tenango"
title: "Map any region in the world with R - Part III: Basic programming with ggplot2"
image: "/post/2022/map_any_region_with_ggplot2_part_I/maps_DrawingMap.png"
draft: true
date: 2023-04-12
description: "Part III of making maps of any region in the world with R using ggplot2 and maps packages"
tags: ["maps-app", "R maps", "Code Visuals", "R functions", "web-scrap", "database"]
categories: ["R"]
archives: ["2023"]
---

You can find all the posts on this series under the tag [maps-app](https://blog.rwhitedwarf.com/tags/maps-app/ "#maps-app") (including the Spanish versions).

You can also find the current state of the project under [my GitHub](https://github.com/teotenn) repo [mapic](https://github.com/teotenn/mapic).

## Scope of this post
We are creating maps of data showing changes over a span of time for different countries and pointing at all kinds of cities. That basically means that we need to **map any region of the world with R**. Today there are all kinds of packages and techniques to do that. I will share the strategy I used with [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html) and [maps](https://cran.r-project.org/web/packages/maps/index.html) packages, using support of [Open Street Map](https://www.openstreetmap.org/) to obtain the coordinates of cities and finally making it interactive with [shiny](https://shiny.rstudio.com/). 

This series of posts share my path towards the creation of the Shiny app. It is a live project and I decided to share my path and experiences along the creation process. The posts are not only about the Shiny app, but the package I created behind it, including topics of functions crafting, creation of the maps, classes of objects, etc., as well as any interesting issue that appear on the way. It is my way to contribute to the R community and at the same time keeping the project documented for myself.

This post is about **Web scrapping with nominatim open street maps**

I hope you all enjoy it. Feel free to leave any kind of comment and/or question at the end.

![R Maps](/post/2022/map_any_region_with_ggplot2_part_I/maps_DrawingMap.png)

```r
map_country_prev <- function(country,
                             x_limits = NULL,
                             y_limits = NULL,
                             show_coords = FALSE,
                             map_colors = default_map_colors) {
  require(maps)
  require(ggplot2)

  ## Verifying the arguments passed to the function
  if (length(country) != 1) stop("Function supports only one country per map")
  stopifnot(is.logical(show_coords))
  stopifnot("Name of the country should be character" = is.character(country))

  if (!country %in% map_data('world')$region) {
    stop(paste("Country name not recognized",
               "To see a list of recognized countries run",
               "<unique(maps::map_data('world')$region)>", sep = "\n"))
  }

  ## If coords limits missing, print worldwide map with coordinates system to allow
  ## User observe coords for reference
  if (missing(x_limits) || missing(y_limits)) {
    warning("X and/or Y limits not provided.\nPrinting worldwide map.")
    map_country_theme <- theme(panel.background = element_rect(fill = map_colors$oceans))
  } else if (show_coords) {
    map_country_theme <- theme(panel.background = element_rect(fill = map_colors$oceans))
  } else {
    if (length(x_limits) != 2 || length(y_limits) != 2 ||
         !all(grepl("^-?[0-9.]+$", c(x_limits, y_limits)))) {
      stop("Limits for X and Y coords should be provided as vectors with two numeric values")
    } else {

      ## All the received inputs are correct.
      ## Let's define our custom theme for the final map
      map_country_theme <- theme_bw() +
        theme(panel.background = element_rect(fill = map_colors$oceans),
              legend.position = "none",
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              axis.line = element_line(colour = "black"),
              axis.title.x = element_blank(),
              axis.text.x = element_blank(),
              axis.ticks.x = element_blank(),
              axis.title.y = element_blank(),
              axis.text.y = element_blank(),
              axis.ticks.y = element_blank())
    }
  }

  ## make a df with only the country to overlap
  map_data_country <- map_data('world')[map_data('world')$region == country, ]
  ## The map (maps + ggplot2 )
  mapic <- ggplot() +
    ## First layer: worldwide map
    geom_polygon(data = map_data("world"),
                 aes(x = long, y = lat, group = group),
                 color = map_colors$border_countries, # border countries
                 fill = map_colors$empty_countries) + # empty countries
    ## Second layer: Country map
    geom_polygon(data = map_data_country,
                 aes(x = long, y = lat, group = group),
                 color = map_colors$border_countries, # border target country
                 fill = map_colors$target_country) + # target country
    coord_map() +
    coord_fixed(1.3,
                xlim = x_limits,
                ylim = y_limits) +
    map_country_theme

  return(mapic)
}


make_dots <- function(.df,
                      year,
                      column_names = list(
                        lat = "lat",
                        lon = "lon",
                        cities = "city",
                        start_year = "year",
                        end_year = NULL),
                      dot_size = 1,
                      map_colors = default_map_colors) {
  require(dplyr)
  require(tidyr)
  require(stringr)

  mandatory_cols <- c("lat", "lon", "cities", "start_year")
  if(!all(mandatory_cols %in% names(column_names))) {
    stop("Column names missing!")
  } else {
    if (!"end_year" %in% names(column_names)) {
      .df$final_year <- NA_real_
      column_names[["end_year"]] <- "final_year"
    }
  }

  ## Dots base size
  base_size <- 5
  dot_sizes <- c(0.5 * (base_size * dot_size),
                 1 * (base_size * dot_size),
                 2 * (base_size * dot_size),
                 3 * (base_size * dot_size),
                 4 * (base_size * dot_size),
                 5 * (base_size * dot_size),
                 7 * (base_size * dot_size),
                 8 * (base_size * dot_size),
                 9 * (base_size * dot_size))

  ## Main data to plot
  filt <- .df  %>%
    mutate(year_final = replace_na(!!sym(column_names$end_year), year + 1),
           city_name = str_to_sentence(!!sym(column_names$cities))) %>%
    filter(year_final > year & !!sym(column_names$start_year) <= year) %>%
    group_by(city_name) %>%
    summarise(x = median(!!sym(column_names$lon), na.rm = T),
              y = median(!!sym(column_names$lat), na.rm = T),
              n = n()) %>%
    mutate(dot_size = case_when(n == 1 ~ dot_sizes[1], 
                                n >= 2 & n <= 5 ~ dot_sizes[2], 
                                n >= 6 & n <= 10 ~ dot_sizes[3], 
                                n >= 11 & n <= 30 ~ dot_sizes[4], 
                                n >= 31 & n <= 50 ~ dot_sizes[5], 
                                n >= 51 & n <= 100 ~ dot_sizes[6], 
                                n >= 101 & n <= 200 ~ dot_sizes[7], 
                                n >= 201 & n <= 300 ~ dot_sizes[8], 
                                n >= 301 ~ dot_sizes[9],
                                TRUE ~ NA))

  ##################### MAIN MAP #######################
  mapic_points <- list(
    geom_point(data = filt,
               aes(x, y, size = dot_size),
               color = map_colors$dots_orgs,
               alpha = 7/10,
               shape = 19) ,
    scale_size_identity('',
                        breaks = dot_sizes, 
                        labels = c('1', '2-5', '6-10', '11-30', '31-50',
                                   '51-100', '101-200', '201-300', '>300'),
                        guide = guide_legend(label.position = 'bottom',
                                             label.vjust = 0,
                                             nrow = 1)),
    geom_point(data = filter(filt, n == 1),
               aes(x, y),
               color = map_colors$dots_orgs,
               shape = 19,
               size = 2.5) ,
    geom_point(data = filter(filt, n >= 2 & n <= 5),
               aes(x, y),
               color = map_colors$dots_orgs,
               shape = 19,
               size = 5),
    theme(legend.position = 'bottom')
  )

  return(mapic_points)
}

mx <- map_country_prev("Mexico",
                       x_limits = c(-118, -86),
                       y_limits = c(14, 34),
                       show_coords = T)

## We can add elements as in ggplot
mx + scale_x_continuous(n.breaks = 20) +
  ggtitle("A map of Mexico")

## webscrap_to_db(db_name = "test-mex.sqlite",
##                dat = mapic::mexico,
##                city = "City",
##                country = "Country",
##                ##state = "Region",
##                db_backup_after = 5)

## remove_na_from_db("test-mex.sqlite")

datmx <- combine_csv_sql(db_file = "test-mex.sqlite",
                         csv_file = mapic::mexico)


myaes <- with_default_aesthetics(sizes = list(basic_dot = 1))

col_names = list(lat = "lat",
                 lon = "lon",
                 cities = "City",
                 start_year = "Registration_year")
                 #end_year = "End_year")

mx + make_dots(datmx,
               year = 2022,
               col_names) 


map_country_prev("Mexico",
                 x_limits = c(-118, -86),
                 y_limits = c(14, 34),
                 show_coords = T) +
  make_dots(rbind(datmx, datmx),
            year = 2022,
            col_names)
## Works



## Make the years
map_print_years <- function(year, x_limits, y_limits, year_label = "Year", map_colors = default_map_colors) {

  ## POSITION FOR THE LABELS
  ## Starting points
  x_units <- abs(x_limits[1] - x_limits[2])/10
  y_units <- abs(y_limits[1] - y_limits[2])/10
  start_x <- min(x_limits)
  start_y <- min(y_limits)
  ## Frame
  rectangle.start.x <- start_x
  rectangle.wide <- rectangle.start.x + x_units
  rectangle.start.y <- start_y
  rectangle.high <- rectangle.start.y + y_units
  ## Text
  num.size <- 4
  text.size <- 3  
  num.position.x <- start_x + (x_units*0.5)
  text.position.x <- start_x + (x_units*0.5)
  num.position.y <- start_y + (y_units*0.25)
  text.position.y <- start_y + (y_units*0.65)
   
  pyears <- list(
    geom_rect(
      aes(xmin = rectangle.start.x, xmax = rectangle.wide,
          ymin = rectangle.start.y, ymax = rectangle.high),
      color = map_colors$text_legend,
      fill = map_colors$text_legend,
      alpha = 9/10),
    geom_text(
      aes(x = num.position.x,
          y = num.position.y,
          label = year),
      size = num.size,
      fontface = 'bold',
      color = map_colors$background_legend),
    geom_text(
      aes(x = text.position.x,
          y = text.position.y,
          label = year_label),
      size = text.size,
      fontface = 'bold',
      alpha = 9/10,
      color = map_colors$background_legend)
  )
  return(pyears)
}


map_print_totals <- function(totals, x_limits, y_limits, totals_label = "Totals", map_colors = default_map_colors) {
  ## POSITION FOR THE LABELS
  ## Starting points
  x_units <- abs(x_limits[1] - x_limits[2])/10
  y_units <- abs(y_limits[1] - y_limits[2])/10
  start_x <- min(x_limits) + x_units
  start_y <- min(y_limits)
  ## Frame
  rectangle.start.x <- start_x
  rectangle.wide <- rectangle.start.x + x_units
  rectangle.start.y <- start_y
  rectangle.high <- rectangle.start.y + y_units
  ## Text
  num.size <- 4
  text.size <- 3  
  num.position.x <- start_x + (x_units*0.5)
  text.position.x <- start_x + (x_units*0.5)
  num.position.y <- start_y + (y_units*0.25)
  text.position.y <- start_y + (y_units*0.65)
  
    ptotals <- list(
        geom_rect(aes(xmin = rectangle.start.x, xmax = rectangle.wide,
                      ymin = rectangle.start.y, ymax = rectangle.high),
                  color = '#283151',
                  fill = map_colors$background_legend,
                  alpha = 9/10),
        geom_text(
            aes(x = num.position.x, y = num.position.y,
                label = totals),
            size = num.size,
            fontface = 'bold',
            alpha = 9/10,
            color = map_colors$text_legend),
        geom_text(
            aes(x = text.position.x, y = text.position.y,
                label = totals_label),
            size = text.size,
            fontface = 'bold',
            alpha = 9/10,
            color = map_colors$text_legend)
    )
    return(ptotals)
}


x_lim <- c(-118, -86)
y_lim <- c(14, 34)
map_country_prev("Mexico",
                 x_lim,
                 y_lim,
                 show_coords = T) +
  make_dots(rbind(datmx, datmx),
            year = 2022,
            col_names) +
  map_print_years(2022, x_lim, y_lim, "Año") +
  map_print_totals(12, x_lim, y_lim, "Totales")


map_country_prev("Germany",
                 show_coords = T) + 
  scale_x_continuous(n.breaks = 20) +
  scale_y_continuous(n.breaks = 20)

x_lim <- c(4, 18)
y_lim <- c(47, 56)
map_country_prev("Germany",
                 x_lim, y_lim,
                 show_coords = T) + 
  map_print_years(2022, x_lim, y_lim) +
  map_print_totals(12, x_lim, y_lim)



map_country_prev("Russia",
                 show_coords = T) + 
  scale_x_continuous(n.breaks = 20) +
  scale_y_continuous(n.breaks = 20)


x_lim <- c(28, 185)
y_lim <- c(10, 100)
map_country_prev("Russia",
                 x_lim, y_lim,
                 show_coords = T) + 
  map_print_years(2022, x_lim, y_lim) +
  map_print_totals(12, x_lim, y_lim)

```