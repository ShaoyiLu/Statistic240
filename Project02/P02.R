```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message=FALSE, error = TRUE,
                      fig.height = 4)
library(tidyverse)
library(lubridate)
library(viridisLite)
```

```{r read-data, echo = FALSE}
## The echo = FALSE argument to this chunk
##   means that the code will not appear in the output
##   but the code will run so that the data is in the session

## Read Lake Monona data
## Change the order of ff_cat from alphabetical to calendar order
## We will see code like this during week 3 of the course
monona = read_csv("../../data/lake-monona-winters-2022.csv") %>% 
  mutate(ff_cat = reorder(ff_cat, ff_x))
```

### Problems

  1. The following code makes a histogram of the `duration` variable in the Lake Monona data set.

```{r problem1}
ggplot(monona, aes(x=duration)) +
  geom_histogram(boundary = 0, binwidth = 10,
                 color = "black", fill = "white")
```

In approximately how many winters was the total duration
where Lake Monona was at least 50% covered with ice between 40 to 70 days?

### Response

```{r solution1}
monona %>% filter(duration >= 40 & duration <= 70) %>%
nrow()
```
Answer: There are 11 days.


  2. Modify the code below so that:

- one of the bin boundaries is at 70 days
- the width of each bin is 5 days
- the fill color is "cyan"
- the color outlining the bars is "forestgreen"
- the x label says "Days Closed with Ice"
- the y label says "Total"
- there is a title with words of your choosing that describe the figure

```{r problem2}
ggplot(monona, aes(x=duration)) + 
  geom_histogram(boundary=70, binwidth=5, fill="cyan", color="red") + 
  xlab("Days Closed with Ice") + 
  ylab("Total") + 
  ggtitle("The Days of Monona Lake with Ice")
```



  3. Code in the next chunk makes a scatter plot that shows how the variable `duration` changes with time (using `year1`).

```{r problem3}
ggplot(monona, aes(x = year1, y = duration)) +
  geom_point() +
  geom_smooth(se=FALSE)
```

- What does the line of code `geom_smooth(se=FALSE)` do?  (Explain what it adds to the plot; you don't need to explain details of the method.)

### Response

Answer: It makes a curve in that graph.



- Describe the pattern of the curve.

### Response

Answer: From 1850 to 2000, the days is decreasing from 120 to 90.



- How long was Lake Monona closed with closed with ice in a typical year near 1875 (i.e., what is the approximate value of the smooth curve around 1875)?

### Response

Answer: It looks like 117 days.



- How long was Lake Monona closed with ice in a typical year near 2000 (i.e., what is the approximate value of the smooth curve around 2000)?

### Response

Answer: It looks like 91 days.




  4. Modify the code in the following chunk so that:

- There is a box plot displaying the distribution of the days Lake Monona is closed by ice  
- The box plot fill color is "yellow"
- The color of the edges of the box plot is "magenta"
- There is a more descriptive y-axis label
- There is an informative plot title

```{r problem4}
ggplot(monona, aes(y=duration)) + 
  geom_boxplot(fill="yellow", color="magenta") + 
  ylab("Total") + 
  ggtitle("The Days of Monona Lake Closed by Ice")
```

- What is the approximate median number of days Lake Monona has been closed with ice?  

### Response

Answer: It looks like 103 days.



  5. Write code to create a bar graph which displays the number of winters when the first freeze occured in each half-month period of time as recorded in the variable `ff_cat`. Choose your own colors if you do not like the default values. Make sure that your plot:
  
- has an informative title and subtitle
- has informative axis labels

```{r}
ggplot(monona, aes(x=ff_cat)) + 
  geom_bar(fill="chocolate", color="yellowgreen") + 
  xlab("Freeze Days") + ylab("Total") + 
  ggtitle("The Days of Monona Lake Freeze", subtitle = "1855 to 2020")
```




6. Briefly explain why you needed to use the command `geom_bar()` and not `geom_col()` to make the plot in the previous problem.

Answer: We needed to create a bar plot to represent categorical variables using 'geom_bar()'. In contrast, we only use the 'geom_col()' function when the data represents continuous variables.


  7. The following chunk creates a scatter plot with `ff_x` on the x axis and `duration` on the y axis, with points colored by `period50`.
The variable `ff_x` is a numerical coding of the first freeze date, counting days after June 30.
For context, December 27 is 180 days after June 30.
The default color scheme is changed to `viridis` which is friendlier to most people with various forms of color blindness.
The command `geom_smooth(method = "lm", se = FALSE)` adds a straight line instead of a curve to the plot (that's the `method = "lm"` argument)
and because we specified `period50` as a grouping variable by mapping it to the color aesthetic, separate lines are added for each group.

Add code to add a plot title and to provide informative axis labels.
Following examples from lecture notes,
change the title of the color legend to say "Time Period" instead of "period50".

```{r}
ggplot(monona, aes(x = ff_x, y = duration, color = period50)) +
  geom_point() +
  geom_smooth(se = FALSE, method = "lm") +
  scale_color_viridis_d() + 
  xlab("First Freeze Day") + ylab("Total") + 
  ggtitle("The Days of Monona Lake Freeze", subtitle = "1855 to 2020") +   guides(color = guide_legend(title = "Time Period"))
```

After making the graph,
suppose that the date of the first freeze in some year was December 27, which is 180 days after June 30.
Based on an examination of the graph,
briefly explain how your prediction of the total duration that Lake Monona is closed by ice would differ if the winter was in the 1870s versus the present?

Answer: During 1870s, it looks totally has 97 freeze days of Monona Lakes which first freeze day is at day 180, but for now, the frist freeze day at day 180 is looked totally has 88 freeze days.

  8. The previous plot used color to distinguish which points were in each 50-year period of time. Write code to plot the same data in a scatter plot, but use a different facet (use `facet_wrap()`, following an example in the lecture notes) for each of the four different 50-year periods of time.

```{r}
ggplot(monona, aes(x = ff_x, y=duration, color=period50)) +
  geom_point() +
  xlab("First Freeze Day") + ylab("Total") +
  ggtitle("First Freeze Days of Monona Lake",
  subtitle = "1855 to 2022") +
  facet_wrap(vars(period50))
```

Does color or faceting make it easier to compare the relationship between first date of closing with ice and the total duration of the freeze among different 50-year time periods?

Answer: Yes, because these data are not coincident, which makes it easier to distinguish each part of the data
