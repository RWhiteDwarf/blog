---
author: "Teoten"
title: "Functions in R"
image: ""
draft: true
date: 2021-11-30
description: "Basic description of functions in R"
tags: ["R tips", "R basics", "R functions"]
categories: ["R"]
archives: ["2021"]
---


## Workflow for writing functions with a practical example
So far we used silly examples to write functions. Let's write a function that can have more practical use. 

There are different ways how to import data from excel to R. Regardless of its limitations, excel is widely used in data analysis, but if you are used to do data analysis with any software, you should be familiar with the complications of sorting your data imported from excel when there are merged cells in the rows. Usually, an excel file like below

![Excel with merged cells](/post/2021/functions/Screenshot_excel_merged_cells.png)

results in a table like this


|Specie |Dup | Treat| Rep| Value|
|:------|:---|-----:|---:|-----:|
|A. cap |A   |     0|   1|    34|
|       |AA  |    NA|  NA|    26|
|       |A   |    25|  NA|    18|
|       |AA  |    NA|  NA|    24|
|       |A   |    50|  NA|    11|
|       |AA  |    NA|  NA|    12|
|       |A   |   100|  NA|    15|
|       |AA  |    NA|  NA|    11|
|F. rub |F   |     0|  NA|    25|
|       |FF  |    NA|  NA|    26|
|       |F   |    25|  NA|    17|
|       |FF  |    NA|  NA|    11|
|       |F   |    50|  NA|    13|
|       |FF  |    NA|  NA|    11|
|       |F   |   100|  NA|    11|

when the amount of rows to be filled in is small, is no big problem to copy and paste the values. But as the DRY principle says, if we know how to create functions there is no need to do that, we can make a function that will do it automatically. This will specially pay off when you will have a table with hundreds or even thousands of cells merged. You might be thinking that nobody will merge cells for thousands of rows every 3 or 4 lines, but believe me, I have seen such things.

### R function to fill in merged cells from excel



## It's not only about R
