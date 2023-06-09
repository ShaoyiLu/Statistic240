```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE,
                      error = TRUE, fig.height = 3)
library(tidyverse)
library(lubridate)
source("../../scripts/viridis.R")
```

```{r}
ord = map_dfr(2017:2021, ~{
  return ( read_csv(str_c("../../data/ORD-", .x, ".csv")) )
})
```

  1. Make the following changes to the data set `ord`.

- Add columns for:
  - *year*;
  - *month* (character valued, use month abbreviations, Jan - Dec);
  - *day* (day of the month); and
  - *wday* (day of the week, character valued, use day abbreviations, Sun - Sat).  
- Reorder the variables so that these new variables all appear directly after the date column.  
- Remove the `terminal` variable.  
- Rename:
  - *all_total* to *passengers*;
  - *all_flights* to *flights*; and
  - *all_booths* to *booths*.  
- Arrange the rows by date and hour.  
- Print all columns of the first 5 rows of this modified data frame
- Print the dimensions of this modified data frame

```{r}
options(tibble.print.extra = "auto", tibble.print.show_info = FALSE, tibble.width = Inf)
Sys.setlocale("LC_TIME", "en_US.UTF-8")

x=ord %>%
  mutate(year=year(date), month=month(date, label=TRUE), day=day(date), wday=wday(date, label=TRUE)) %>%
  select(-terminal) %>%
  relocate(airport, date, year, month, day, wday) %>%
  rename(passengers = all_total, flights = all_flights, booths = all_booths) %>%
  arrange(date, hour)

x %>%
  slice_head(n=5)
x
```
```{r}
dim(x)
```

  2. Are there any dates in the range from January 1, 2017 through December 31, 2021 that are missing? If so, which ones?

```{r}
temp1 = expand_grid(
  date = seq(ymd("2017-01-01"), ymd("2021-12-31"), 1))

temp2 = x %>% 
  select(date) %>% 
  distinct()

temp1 %>% 
  anti_join(temp2)
```

  3. Modify the `ord` data set by:

- Adding a variable named `time_of_day` which categorizes the `hour` variable in the following way:

  - midnight to 4am ("0000 - 0100" through "0300 - 0400") is "overnight"
  - 4am to 8am is "early morning"
  - 8am to noon is "morning"
  - noon to 4pm is "afternoon"
  - 4pm to 8pm is "early evening"
  - 8pm to midnight is "late evening"
  
- After adding the `time_of_day` variable, this chunk of code will reorder the levels to match the times and not alphabetically.
  - This is useful so you get the desired order in summary tables and plots.
  - The function `fct_relevel()` is part of the **forcats** package in **tidyverse** which we will not study in depth.
  - Use this code (or something like it) in your solution.
  

```{r}
y = x %>% 
  mutate(first_hour = as.numeric(str_sub(hour, 1, 4))) %>% 
  mutate(time_of_day = case_when(
    first_hour >= 0 & first_hour < 400 ~ "overnight",
    first_hour >= 400 & first_hour < 800 ~ "early morning",
    first_hour >= 800 & first_hour < 1200 ~ "morning",
    first_hour >= 1200 & first_hour < 1600 ~ "afternoon",
    first_hour >= 1600 & first_hour < 2000 ~ "early evening",
    first_hour >= 2000 & first_hour < 2400 ~ "late evening")) %>% 
    mutate(time_of_day = reorder(time_of_day, first_hour)) %>% 
  select(-first_hour)

v = y %>% 
  count(time_of_day, hour) %>% 
  distinct() %>%
  print(n=Inf)
```

- Create a summary table which counts the number of rows for each `time_of_day` and `hour` combination. Verify that the top ten rows of your data set match these values.

```
   time_of_day   hour            n
   <fct>         <chr>       <int>
 1 overnight     0000 - 0100  1345
 2 overnight     0100 - 0200   538
 3 overnight     0200 - 0300   167
 4 overnight     0300 - 0400   125
 5 early morning 0400 - 0500   520
 6 early morning 0500 - 0600  1024
 7 early morning 0600 - 0700  1355
 8 early morning 0700 - 0800  1286
 9 morning       0800 - 0900  1434
10 morning       0900 - 1000  1447
```

- Create an additional summary table which calculates the total number of flights which arrive during each of these time periods. This table will have six rows.

- Print the table.

```{r}
z = y %>% 
  group_by(time_of_day) %>% 
  summarize(total_flights = sum(flights))
z
```


  4. Use a bar graph to display the total number of flights in each time period as calculated in the previous problem. There should be six categories of time period from "overnight" to "late evening".
Add a title and meaningful axis labels.  

```{r}
ggplot(z, aes(x = time_of_day, y = total_flights)) +
  geom_bar(color = "green4", fill = "skyblue2", stat="identity") +
  xlab("Time of Day") +
  ylab("Total Flights") +
  ggtitle("Chicago Flights from 2017 to 2021")
```


  5. Create a data summary table with the average daily number of passengers by month and year.
  
- Display this data summary with a bar chart where month is on the x-axis and average daily passenger counts are on the y axis 
- Add meaningful axis labels and a title to this graph.  
- Change the y axis scale labels so values are regular numbers with commas. *(Use `scale_y_continuous()` as below)*
- Display the graph with a different facet for each year



```{r, fig.height = 6}
## data summary
prob5 = y %>% 
  group_by(date, year, month, day, wday) %>%
  summarize(total_passengers = sum(passengers)) %>%
  group_by(year, month) %>% 
  summarize(avg_passengers = mean(total_passengers))
  
## plot the table  
ggplot(prob5, aes(x = month, y = avg_passengers)) +
  scale_y_continuous(label = scales::comma) + 
  geom_bar(color = "tan4", fill = "tomato", stat="identity") +
  xlab("Month") + ylab("Average Daily Number of Passengers") +
  ggtitle("Chicago Airport Passenger Counts", subtitle = "2017 to 2021") + 
  facet_grid(vars(year))
```


  6. What striking feature is apparent in this graph?
What explains this feature of the data?

> Beginning in 2020, the number of passengers on international routes at Chicago Airport has significantly decreased, possibly due to the epidemic.



  7. Investigate the average number of passengers per day of the week for the years 2017--2019.

- For each day of the week (Sunday -- Saturday), calculate the average number of arriving daily passengers to ORD on international flights. Display this table sorted from highest to lowest average.
*(Hint: you need to total passengers by date and day of week before taking averages.)*
- Print the entire table

```{r}
w = y %>% 
  filter(year <= 2019) %>% 
  group_by(date, wday) %>% 
  summarize(total_passengers = sum(passengers)) %>% 
  group_by(wday) %>% 
  summarize(avg_passengers = mean(total_passengers)) %>% 
  drop_na() %>%
  arrange(desc(avg_passengers))
w
```



  8. Identify the 20 dates with the highest total number of arriving passengers.
How many of these dates are the day of the week identified in the previous problem with the highest average?

```{r}
u = y %>% 
  group_by(date, wday) %>% 
  summarize(total_passengers = sum(passengers)) %>% 
  ungroup() %>% 
  slice_max(total_passengers, n = 20)
u
```
```{r}
u %>%
  count(wday) %>%
  ungroup() %>%
  slice_max(n)
```
