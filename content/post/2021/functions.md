---
author: "Teoten"
title: "Functions in R"
image: ""
draft: false
date: 2021-11-28
description: "Basic description of functions in R"
tags: ["R tips", "R basics", "R functions"]
categories: ["R"]
archives: ["2021"]
---



## Background

This is the first post of R with White Dwarf and I decided to start this blog with a basic tutorial. There is already a lot of information in the web about getting started with R. With a simple google search you can easily find info on how to install it, how to use R studio or other text editor, learn about the basic functions and concepts, what is a vector, a data frame, how to use them, etc. Therefore, I decided to start with a topic that is also basic but slightly less common: Functions.

How to create a function is not an easy topic for non-programmers and non-mathematicians, Myself I have a background in ecology and when I started using R for my statistical analysis I was avoiding using functions at all cost, while most of my colleagues where avoiding R fully. Many people has the idea that, as a programming language, R is really difficult to use and it should be left for the initiated ones. They end up using user interface based-software which assumes not only that the user doesn't know about programming, but also about statistics. It limits the possibilities of what you can do with your data and as a result, it limits also what you can learn. 

In today's world, it is important to to have at least a basic understanding of programming. **[DEVELOP MORE HERE]**

## How to write functions in R

Using R is not difficult and creating functions the same. Basically, when we use R we are using functions all the time. When you want to obtain the summation of values, or the mean or standard deviation, you are simply calling a function to do that. 

```r
values <- c(2, 3, 4, 5)
sum(values)
```

```
> [1] 14
```
As you should already know from any R tutorial, the example above is storing the values in the vector `value` and the calling the functions `sum` to obtain the summation of the values. One way to create our own function of sum would be:

```r
my_sum <- function(user.values){
    cumulative.sum <- user.values[1]
    for(i in 2:length(user.values)){
        cumulative.sum <- cumulative.sum + user.values[i]
    }
    return(cumulative.sum)
}
```
Now we can call our brand new function and obtain the same results


```r
my_sum(values)
```

```
> [1] 14
```
Let's go piece by piece. Line no. *1* is simply placing the function that we are creating into the object `my_sum` which means that later, we can call our function using that same word: `my_func(some values)`. This is similar to creating a vector or data frame or variables, as you know, if you enter `x <- 12` then each time you type `x` in the console it will return the value `12`, and so it explains line *2*, when we define `cumulative.sum <- user.values[1]` this storage the first value defined by the user into the variable `cumulative.sum`. It means that now we can start by adding the second value to the `cumulative.sum`, then we move forward to the third value, and so on until the end of the table. This is define in the for loop: we move value by value from the second element to the last one: `for(i in 2:length(user.values))`, each time we stored the cumulative value in our variable `cumulative.sum` until we reach the last value. I will not go deep into the for loop, but I understand that it can also be somehow complicated for a beginner, if it is your case I invite you to leave us a comment (you will need a github account for that) and I might cover it in a future issue.

Once we are outside the for loop we already have the final value stored in `cumulative.sum`, so we make sure that our function is returning exactly that by using `return(cumulative.sum)`. If you have seen some other tutorials you might have noticed that the `return()` is not always added at the end of the function. And indeed, it is not strictly necessary (more on that later), but as a beginner it is good to start with good habits and defining what exactly you want your function to return is a good habit for your future functions. 

### Simple error handling

When you work with functions you need to tell the user what exactly went wrong in order to help him fix it. Even if you are writing functions only for yourself, after a while has passed you might forget all the logic behind your function and thus, obtaining errors that you don't understand where they come from. A basic knowledge of error handling can help us prevent that.

What I'm explaining here is a very basic and simple management of errors but yet, practical and useful, it can save us wasted time and headaches. It is something I wish I had learned when I started writing my first functions. Due to my ignorance it used to take me a lot of time just to figure out what was wrong with my own code. 

Let's go back to our function. As you probably already noticed, it starts summing up from the second value in the vector, therefore if we provide only one value instead of a vector of values the result will be `NA`


```r
my_sum(12)
```

```
> [1] NA
```
quite silly compared to the professional function from base-R which returns the value itself


```r
sum(12)
```

```
> [1] 12
```
We could try to imitate the base-R `sum()` and continue in that direction, but instead we are going to have a little fun with simple examples of errors. Let's say that instead of returning the value itself, we want our new function to send an error when a single value is entered. For that, we simply need to check if the value size is bigger than 1, and if not, send the error. We can achieve that with an if statement:


```r
my_sum <- function(user.values){
    if(length(user.values) == 1){
        stop('We cannot sum individual values here!')
    }
    cumulative.sum <- user.values[1]
    for(i in 2:length(user.values)){
        cumulative.sum <- cumulative.sum + user.values[i]
    }
    return(cumulative.sum)
}
```
As you can see in line *2*, we will enter inside the if-part-of-code if the length of the values is one (we cannot have length smaller than 1, if we run the function without a value, R will say that the argument is missing), calling `stop()` which basically stops the function at that point, and exits printing whatever message you define inside it. Go ahead and try it.

```r
my_sum(12)
```

```
> Error in my_sum(12): We cannot sum individual values here!
```
I am sure that with this basic info you can move forward and improve it even more to send an error message when an object other than a vector is entered. Some hints: You can use the function `is.vector()` to test if the value entered by the user is a vector or not; and you can place one if statement inside the other, first to check if it is a vector, and secondly to check its size.

### Function arguments

You might be wondering what about the argument used as variable `user.values`, where does it come from? how is it defined? how does R knows how to use it? Keeping it simple, all the arguments that you define inside the parenthesis of a function will be searched by R when you execute the function and use them accordingly. You can easily see how we were using the variable `user.values` to tell the rest of the program what to do with it. The function has no idea if the user will enter a single value, a vector or a data frame, this is the reason why we created the errors with `stop()`. As the creator of the function, it is your role to decide what kind of object you need, how to use it and how to ensure that the user knows what is wrong if an unexpected object is entered. 

You can define as many arguments as you wish for your function, for example


```r
sum_four_nums <- function(num1, num2, num3, num4){
    return(sum(num1, num2, num3, num4))
}

sum_four_nums(2, 4, 6, 8)
```

```
> [1] 20
```
Here we are telling R to take the four values entered by the user and sum them up. R will check the values in the order they are entered, so in our example it will associate the value 2 with our first variable `num1`, then the value 4 with the second variable `num2` and so on. If we miss one of the values, R will tell us that one of the variables is missing


```r
sum_four_nums(2, 4, 6)
```

```
> Error in sum_four_nums(2, 4, 6): argument "num4" is missing, with no default
```
If we want to allow the user to provide only 3 values, we can initialize one of them as null


```r
sum_four_nums <- function(num1, num2, num3, num4 = NULL){
    return(sum(num1, num2, num3, num4))
}

sum_four_nums(2, 4, 6)
```

```
> [1] 12
```
This means that we can actually initialize our variables with whatever we want to put on it, for example we can tell our function to always add 10 if only 3 values are entered by the user


```r
sum_four_nums <- function(num1, num2, num3, num4 = 10){
    return(sum(num1, num2, num3, num4))
}

sum_four_nums(2, 4, 6)
```

```
> [1] 22
```
Also notice that we are telling R to take strictly four values, and not a vector of size 4. If we do this, R will associate the vector to the variable `num1` as one object and will complain that the other arguments are missing


```r
sum_four_nums(c(2, 4, 6, 8))
```

```
> Error in sum_four_nums(c(2, 4, 6, 8)): argument "num2" is missing, with no default
```
As I mentioned already, R is not aware of what type of object the user should enter, therefore we could as well enter only vector, or vector and numbers, and R will simply apply the `sum()` function to whatever is inside it, because this is how we defined our function


```r
sum_four_nums(c(2, 4, 6, 8), 20, 50)
```

```
> [1] 100
```
Here R is summing first all values contained in the vector, then 20 and 50, and finally the predefined 10. As you can see, the proper handling of errors is important when you want to ensure that you function does what is intended to do, or to help you or the user identify what exactly when wrong. 

### Functions without arguments

You can also define functions without arguments, meaning without direct input from the user. For example, let's write the classical Hello World!, a function that, when called, prints the sentence itself


```r
hello_world_function <- function(){
    print('Hello World!')
}

hello_world_function()
```

```
> [1] "Hello World!"
```
As you can see, in line *1* when we define the function there is nothing inside the parenthesis and thus, when we call the function we don't need to include anything inside it. This example might look silly, but sometimes we want the functions for their side effects, rather than for the values they return.

When we write a function, R will search for the variable inside the function

```r
sum_my_vector <- function(){
    my.vector <- c(10, 20, 30)
    return(sum(my.vector))
}

sum_my_vector()
```

```
> [1] 60
```

```r
ls()
```

```
>  [1] "base.dir"             "base.url"             "changing.wd"         
>  [4] "dirs"                 "fig.path"             "func.params"         
>  [7] "hello_world_function" "my_sum"               "rmd.file"            
> [10] "rmd.path"             "sum_four_nums"        "sum_my_vector"       
> [13] "values"               "work.in"
```
As you can see, the vector called `my.vector` is created inside the function and thus, when we call it, the function returns the sum of the vector. However, when we list all the objects in memory using `ls()`, the object `my.vector` doesn't exists. All the objects that we define inside the function live only there. If we now create an object called `my.vector` and call again the function, the result will not change


```r
my.vector <- c(1, 2, 3)
sum_my_vector()
```

```
> [1] 60
```

```r
ls()
```

```
>  [1] "base.dir"             "base.url"             "changing.wd"         
>  [4] "dirs"                 "fig.path"             "func.params"         
>  [7] "hello_world_function" "my_sum"               "my.vector"           
> [10] "rmd.file"             "rmd.path"             "sum_four_nums"       
> [13] "sum_my_vector"        "values"               "work.in"
```
The reason is that R functions search for objects inside the function. Therefore, you could give the same names to objects inside and outside the functions without affecting the outcome, however this is not recommended because it might cause confusion in the future. Another reason why is not recommended is that R searches for the object inside the function first, but when it cannot find it, it searches for the object outside of the function, in your working environment (it means, what we can see listed by `ls()`), for example


```r
sum_other_vector <- function(){
    return(sum(my.vector))
}

sum_other_vector()
```

```
> [1] 6
```
here I have created a similar function but this time I did not create the object `my.vector` inside it, therefore R is using the one that I loaded into the working environment as `my.vector <- c(1, 2, 3)`. 

We could consider the objects created inside the function as local variables, and the ones defines outside of the function as global variables. Other programming languages handle this two kinds of variables differently, often by initiating the global variables with special characters, or creating them using special functions, in order to avoid mistakes and confusion. In R you should be very careful on how you name your objects and where you use them when you are creating functions.

On the other hand it has the advantage that it is very easy to create functions that use the same structure of data. For example, I could create a data frame called `elements` that will always contain the columns called `Pb`, `As`, `Cd` and `Zn` and then just make functions that take no arguments to do all my statistics at once by calling the same table and the same columns inside them. 

## Why to write functions

As mentioned above, I started writing functions when I did my Ph.D. I was working with contaminated soils and basically for all my projects I had to analyze data of concentration of elements. This means that for each project, I had to repeat the same process for each element and then, for the next project do the same for the new data and for other or more elements. Luckily my first project was only about 4 different elements. I did a script for the statistics and visualizations of the first element, organize the workflow, decided what would be variable and what constant, and created two functions, one for the statistics and one for the visualizations, based on the output of the first one, and then just applied the functions to the remaining 3 elements.

When I got the first results of my second experiment it was about more than 10 different elements, and that only for soils, I knew that later I'd have to do the same for different parts of the plants. Therefore I decided to create a package. I simply googled how to put all together in a package, installed it and then, for each of my next data results I could simply call it in my R environment and do all the statistical analysis way faster than I can even measure. 

Learning how to write functions in R can save a lot of time in any kind of work you are doing. It can reduce the time you need for your data analysis and the amount of code written in your scripts. As a result it also makes your code more organized and more understandable. It can also help you to understand better how R works, as you need to get more familiar with the type of objects used, the structures of the functions, the application of conditionals and iterative processes, etc. 

Functions are a key element of most (probably all) programming languages and thus, learning how to create your own will also develop your programming skills and teach you how to automatize tasks. There is a general informal rule for programming that is called the DRY principle, which means **D**on't **R**epeat **Y**ourself. In other words, if there a process in your code/program/script that has to be repeated at least once, it is worth it to write a function and then call it twice with the different arguments that will be variable rather than coping the whole code from the first case and pasting it where the second case needs it and only changing the arguments that are variable in the second case. The following sections will explain more on that.


## Workflow for writing functions with a practical example
So far we used silly examples to write functions. Let's write a function that can have more practical use. 

There are different ways how to import data from excel to R. Regardless of its limitations, excel is widely used in data analysis, but if you are used to do data analysis with any software, you should be familiar with the complications of sorting your data imported from excel when there are merged cells in the rows. Usually, an excel file like below

![Excel with merged cells](/post/2021/functions/Screenshot_excel_merged_cells.png)
results in a table like this


Table: Result in R

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
