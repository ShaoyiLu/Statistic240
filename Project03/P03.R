```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE,
                      message=FALSE, warning = FALSE,
                      fig.height = 3,
                      error = TRUE)
library(tidyverse)
library(lubridate)
source("../../scripts/viridis.R")
```

### Problems

The following R chunk reads in the default exoplanet data,
selects some variables, and changes some variable names.

```{r read-planet-data}
## Read in the csv file
planets = read_csv("../../data/exoplanets-clean-through-2022.csv") 
```


  1. A small number of planets have both an estimated mass AND an estimated radius less than those of the Earth.  What are the names of these planets, what method(s) were used to detect them, and in what year were they discovered?

- Create a data summary table with the star name, planet name, method, year, mass, and radius of the planets that have **both** an estimated mass < 1 Earth mass **and** an estimated radius < 1 Earth radius.  
- Order the rows increasing by mass.-
- Print the entire table.

```{r}
x=planets %>%
  select(star, planet, method, year, mass, radius) %>%
  drop_na() %>%
  filter(mass<1 & radius<1) %>%
  arrange(mass)
print(x)
```




  2. Using the exoplanet data table `planets`:

- filter so that you only use planets discovered by the radial velocity method;
- remove cases where either of the variables `year` or `mass` (or both) are missing;
- for this subset of exo planets, create a table with a data summary with the number of planets discovered and the minimum mass of these planets by year
- print the first 10 rows and all columns of this data summary

Then, make a scatter plot of this data such that:

- the size of points are proportional to the number of planets discovered that year
- the y-axis is on the log10 scale *(hint:  consider `scale_y_continuous()` or `scale_y_log10()`)*
- the axes have descriptive labels, and
- the plot contains an informative title.

Note, a scatter plot where the size of the points is proportional to a numerical variable is called a *bubble plot*.

In addition to creating the graphic, respond to the question below the R chunk.

```{r}
x=planets %>%
  filter(method == "Radial Velocity") %>%
  select(year, mass) %>%
  drop_na() %>%
  group_by(year) %>%
  summarize(n=n(), min=min(mass))
head(x, n=10)
```
```{R}  
ggplot(x, aes(x=year, y=min, size=n)) +
  geom_point() + 
  scale_y_continuous(trans="log10") + 
  xlab("Years") + ylab("Minimun mass of planets") + 
  ggtitle("Minimum mass of explored planets each year")
```

**Describe the pattern between year and minimum mass of planet discovered using Radial Velocity.**

Answer: It looks like that the mass of the discovered planet gradually decreases over time.




  3. Using the `planets` data set created at the beginning of the assignment
*(not the reduced data set from the previous problem)*,
determine which methods have been used to discover fewer than 50 planets each. For use in the remaining exoplanet problems,
create a subset of the data by:

- removing the planets discovered by those methods (with fewer than 50 exoplanet  discoveries)
    - *(Hint: A clever solution uses a filtering join function, either `semi_join()` or `anti_join()`, but you have not seen these yet in lecture. Also consider creating a column which contains for each method the total number of times that the method appears in the data set prior to using that information inside of `filter()`.)*
- summarize *for each year*, the number of planets and the proportion of planets discovered by each method used 50 or more times. *(Note: methods are used 50 or more times in the entire data set. Counts in a single year may be less.)*
  - proportions should sum to one within each year.
- arrange the rows by year in chronological order (earliest first)

This data summary should have one row for each year and method (if the method was used in that year) and columns with the names `year`, `method`, `n`, and `proportion`.
*(Hint: you may find it helpful also to create a `total` column with the total number of exoplanets discovered each year repeated for each row to help calculate the proportion.)*

```{r}
y=planets %>%
  count(method) %>%
  filter(n>=50) %>%
  pull(method)

z=planets %>%
  filter(method %in% y) %>%
  group_by(year, method) %>%
  summarize(n=n()) %>%
  mutate(total = sum(n),
         proportion = n/total)
dim(z)
```

Print the first 10 rows and all columns of this data summary.

```{r}
head(z, n=10)
```





  4. Using this data summary, create and display a bar plot with the year on the x axis and the proportion of discovered planets on the y axis.  Let each year have a single bar that extends from a proportion of 0 to 1, with sections of each bar filled with a color by method
Add appropriate axis labels and plot title.

```{r}
ggplot(z, aes(x=year, y=proportion)) + 
  geom_col(aes(fill=method)) + 
  xlab("Years") + ylab("Proportion") + 
  ggtitle("Different ways of finding planets every year")
```


Which method was most successful with the earliest discoveries of exoplanets, and which method has supplanted that method in relative popularity in recent years?

Answer: Radial Velocity







  5. Begin with the data summary from the previous problem.

- filter to only include years from 2010 -- 2022 (include the endpoints of the range), and
- remove the rows corresponding to the "Transit" or "Radial Velocity" methods.

Using this modified data set, create a plot which:

- displays the *counts* of exoplanets discovered by method with a bar graph with year on the x axis, different fill colors for each method,
and the *counts* of the number of planets for each year and method on the y axis using the function `geom_col()`.
- does not stack the bars for each year, but rather display them next to each other in a clump by each year label.
(*Note: The default is to stack bars. Use the argument `position = position_dodge2(preserve = "single")` inside of `geom_col()` to avoid stacking and to preserve the same bar width when the number of methods present changes by year.*)
- adjusts the x-axis so a tick mark and label appears for each year (i.e., 2010, 2011, ..., 2022).  **(Hint: consider `scale_x_continuous()`.)**
- uses appropriate axis labels and plot title.

```{r}
new_graph = z %>%
  filter(year>=2010 & year<=2022) %>%
  filter(method !="Transit" & method != "Radial Velocity")

ggplot(new_graph, aes(x=year, y=n)) + 
  geom_col(aes(fill=method), position=position_dodge2(preserve="single")) + 
  xlab("Years") + ylab("Discovered planets") + 
  ggtitle("Methods to discovery new planets every year")
```






```{r, include = FALSE}
official = read_csv("../../data/madison-weather-official-1869-2022.csv")
```

  6. Use the official Madison weather data. Find:

- **6a**. The dates with the five highest recorded maximum temperatures (there could be more than five dates due to ties)

```{r}
official %>%
  select(date, tmax) %>%
  slice_max(tmax, n=5)
```



- **6b**. The proportion of all days by month with positive precipitation.

```{r}
official %>%
  select(date, prcp) %>%
  drop_na() %>%
  mutate(month=month(date, label=TRUE)) %>%
  mutate(precipitation=prcp, prcp>0) %>%
  group_by(month) %>%
  summarize(n=n(), sum_prcp=sum(precipitation), avg_prcp=sum_prcp/n)
```



- **6c**. The average temperature (mean of `tavg`) by month for the years from 1991-2020. Consider these values to be the current *normal mean temperatures*. Then, find the average temperature by month in 2022. In how many months was the average temperature in 2022 higher than the normal mean temperature?

```{r}
x = official %>%
  mutate(year=year(date), month=month(date, label=TRUE)) %>%
  filter(year>=1991) %>%
  mutate(time = case_when(
  year < 2022 ~ "1991-2020",
  year == 2022 ~ "2022")) %>% 
  drop_na() %>%
group_by(month, time) %>% 
summarize(tavg = mean(tavg))

x %>% 
  head(n = Inf)
```

Answer: 7 months




- **6d**. The ten years with the highest average temperature on record since 1869. How many of these years have occurred since 2000?

```{r}
official %>% 
  mutate(year = year(date)) %>% 
  select(date, year, tavg) %>% 
  drop_na() %>% 
  group_by(year) %>% 
  summarize(tavg = mean(tavg)) %>% 
  slice_max(tavg, n = 10) %>% 
  mutate(recent = case_when(
    year >= 2000 ~ "At current century",
    year < 2000 ~ "At last century"))
```





  7. The mean daily average temperature in Madison in January, 2023 was 27.02 degrees Fahrenheit.

- Calculate the mean average daily temperature for each January from the official Madison weather data.
- Create a subset of this data set with the year and mean daily average temperature for the highest 25 of these years, arranged from highest to lowest value. Add an initial column named `rank` with values from 1 to 25. Print this entire data summary table
- In terms of mean daily average temperature in January, how does 2023 compare to all previously recorded months in Madison since 1869?
  
  
```{r}
january=official %>%
  group_by(year(date)) %>%
  filter(month(date)==1) %>%
  summarize(avg=mean(tavg)) %>%
  drop_na() %>%
  arrange(desc(avg)) %>%
  head(25) %>%
  mutate(x=1:25)
january
```

Answer: The temperature in 2013 is relatively high, and it has already ranked in the top ten of so many data.
  



  8. Make a plot which shows the average January temperature in Madison from 1869--2022. Add a smooth trend curve to the plot. Add a red dashed horizontal line at the mean temperature for 2023. Include meaningful axis labels and a title for the plot.
  
```{r}
x=official %>%
  mutate(year=year(date), month=month(date)) %>%
  select(date, year, month, tavg) %>%
  filter(month==1) %>%
  drop_na() %>%
  group_by(year, month) %>%
  summarize(tavg=mean(tavg))

ggplot(x, aes(x=year, y=tavg)) +
  geom_point() + geom_smooth(z=TRUE) + 
  geom_hline(linetype="dashed", yintercept = 27.02, color="red") + 
  xlab("Years") + ylab("Average") + 
  ggtitle("The average of temperature in each year")
```



