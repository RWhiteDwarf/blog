---
title: Map any region with ggplot2 part II - Using recursion
date: "2023-01-14"
format: hugo-md
tags: ["R maps", "Code Visuals", "R functions", "web-scrap", "database"]
draft: true
---

## Scope of this post

This is the second part of the series to create a map of any region of the world with R.

We are creating maps of data showing changes over a span of time for different countries and pointing at all kinds of cities. That basically means that we need to **map any region of the world with R**. Today there are all kinds of packages and techniques to do that. I will share the strategy I used with [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html) and [maps](https://cran.r-project.org/web/packages/maps/index.html) packages, using support of [Open Street Map](https://www.openstreetmap.org/) to obtain the coordinates of cities and finally making it interactive with [shiny](https://shiny.rstudio.com/). The project is quite long for a single post, so my idea is to split it into a few smaller blog posts. So far, the list is a follows:

1.  [The basic map](https://blog.rwhitedwarf.com/post/map_any_region_with_ggplot2_part_i/)
2.  **Web scrapping with nominatim open street maps**
3.  Maps with cities
4.  Dynamic maps in time
5.  Making a single script for fast replication
6.  Making the code interactive in a shiny app

The ideas is to share the how-to of one of the projects I am most proud of and, at the same time to give back to the R community in hopes that it can help somebody else.

I hope you all enjoy it. Feel free to leave any kind of comment and/or question at the end.

![R Maps](../../../../post/2022/map_any_region_with_ggplot2_part_I/maps_DrawingMap.png)

## Open Street Maps and Nominatim

``` r
x <- rnorm(100)

print(mean(x))
```

    [1] -0.129577

## Testing tabsets

## R

``` r
x <- c(1, 2, 3)
```

## emacs-lisp

``` emacs-lisp
(setq x '(1 2 3))
```

## Testing code chunks

<details>
<summary>Show the code</summary>

``` r
a <- c(1:10)

for(i in a){
    print(i*10)
}
```

</details>

    [1] 10
    [1] 20
    [1] 30
    [1] 40
    [1] 50
    [1] 60
    [1] 70
    [1] 80
    [1] 90
    [1] 100

AAA

`{{r executable}} print("A silly string")`
