---
title: "My final test"
date: 2021-11-26T13:07:36+01:00
draft: true
---

# An R post
This is the final script to test my script `knit_it.R`


```r
library(ggplot2)
library(dplyr)

smaller <- diamonds %>% 
  filter(carat <= 2.5)
```

We have data about 53940 diamonds. Only 
126 are larger than
2.5 carats. The distribution of the remainder is shown
below:

![plot of chunk unnamed-chunk-1](/post/personal/Manu/unnamed-chunk-1-1.png)
