---
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message = FALSE, error = TRUE)
```

### Problems

  1. This problem checks if you can execute a base R command by generating a vector of 50 random integers from something called a Poisson distribution.
Change the argument in the chunk header from `eval = FALSE` to `eval = TRUE` and evaluate the chunk.

What is the 30th value in the vector?

Note that when a vector is written out in the output, each line is preceded by a label which indicates the index of the first value on that line. So `[1]` on the first line means that line begins with the first element.
A line of output which begins with `[10]` would start with the 10th element of the vector.

```{r, eval = TRUE}
## set a random seed so all answers are the same
set.seed(2023)

## generate 50 random numbers from a Poisson distribution with mean 15
rpois(50, 15)
```

Answer is 14



  2. This problem checks that you have correctly installed the **tidyverse** packages. It loads the package with `library()`, accesses a data set named trees, and prints a summary table with `n` equal to the number of rows in the data set and `average` equal to the mean of the variable `Height`.
  
Change the chunk label from `eval = FALSE` to `eval = TRUE` and respond to the question.

What is the average value of the variable `Height`?
  
 
```{r, eval=TRUE}
library(tidyverse)
data(trees)
summarize(trees, n = n(), average = mean(Height))
```

Answer is 76


  
  3. Write code in the following R chunk to create a vector named `a1` by using the colon operator (`:`) with the values from 1 to 8.
  Also, create a vector named `a2` with the same values using `seq()`.
  Then, type the names of these each of these two vectors alone on separate lines so that their values appear in the output.
  
```{r}
   a1 <- 1:8
   a2 <- seq(1, 8)
   a1
   a2

```
  


  4. What is the sum of all even integers from 2 to 500? Write code in the R chunk using `seq()` and `sum()` to do the calculation.
  Then, outside of the R chunk, delete the text "REPLACE THIS TEXT WITH YOUR RESPONSE" and replace it with a sentence that provides the answer to the question, such as
  
> The sum of the even integers from 2 to 500 is X.

Your sentence will use a number instead of X.

```{r}
   a1 <- seq(2, 500, 2)
   a2 <- sum(a1)
   a2
```

Answer is 62750


  5. Write a short sentence to explain what the symbol `^` does in the following code chunk.
  
```{r}
2^seq(0, 5, 1)
```

"^" is used to raise a number to the power of an exponent.



  Problems 6--8 use this data.

The following R chunk creates a vector of 10 random numbers which are rounded to one decimal place and sorted from smallest to largest.
These values are used in the remaining problems in this assignment.
  
```{r}
x = sort(round(rnorm(10, mean = 20, sd = 5), 1))
x
```

  6. Write code to calculate the minimum and maximum using `min()` and `max()` and verify that the answers are correct.

```{r}
min(x)
max(x)

```


  7. Calculate the median of these values. Write a brief sentence to explain why this calculated value is the median.
*(The median is the "middle value" in a sorted list of numbers. What does "middle" mean when there are an even number of values in the list, at least as encoded in the function `median()`?)*

```{r}
median(x)
```

The middle value is considered the median because it splits the set of values into two equal halves, with half the values being greater than it and half being less than it.



  8. Calculate the value of the expression below by using the values in `x` for the vector $x = (x_1, \ldots, x_n)$, where $\bar{x}$ stands for the mean of the values in $x$. Here, $n=10$ is the length of our list of numbers.
In other words,
subtract the mean from each individual value in `x`,
square these values individually,
and then sum up these squared differences to get a single value.
Your solution may break this calculation up in many steps, naming the partial calculations and using these values subsequently,
or, you can do everything in a single expression.

$$
\sum_{i=1}^n (x_i - \bar{x})^2
$$

```{r}
sum((x-mean(x))^2)
```
