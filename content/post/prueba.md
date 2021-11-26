---
title: "Prueba"
date: 2021-11-26T13:07:36+01:00
draft: true
---

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

![plot of chunk unnamed-chunk-1](/post/prueba/unnamed-chunk-1-1.png)
