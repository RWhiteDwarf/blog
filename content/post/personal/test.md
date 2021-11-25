---
author: "Manuel T."
title: "Basic setup"
image: "img/prism.jpg"
draft: true
date: 2021-11-25
description: "Basic setup of Rmd"
tags: ["personal"]
categories: ["personal"]
archives: ["2021"]
---
# General info

# An R post


```r
library(ggplot2)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
smaller <- diamonds %>% 
  filter(carat <= 2.5)
```

We have data about 53940 diamonds. Only 
126 are larger than
2.5 carats. The distribution of the remainder is shown
below:

![plot of chunk unnamed-chunk-1](/post/personal/figure/unnamed-chunk-1-1.png)

 For images, we can tell `knitr` to store the resulted images in the static directory, like:
 
 

```r
opts_knit$set(base.dir = '/home/teoten/Code/WebApps/Rwhitedwarf-blog/static/post/test/')
```
Here, the final folder *test* does not yet exists, but it'll be created.

Then running `knitr::knit("post.Rmd")` will render the md file to the corresponding path. We still need to fix how the path is included in md file by adding the relative path of the image after `static` folder
