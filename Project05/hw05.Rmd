---
author: "Shaoyi Lu"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message = FALSE,
                      warning = FALSE, error = TRUE,
                      fig.height = 3)
library(tidyverse)
library(lubridate)
source("../../scripts/viridis.R")
```

## Assignment 5

#### Due Friday, March 3, 11:59 PM CT

### Preliminaries

- Directories
    - COURSE/homework/
    - COURSE/homework/hw05/
    - COURSE/data/
    - COURSE/scripts/
- Files
  - COURSE/homework/hw05/hw05.Rmd
  - COURSE/data/obesity.csv
  - COURSE/data/education.csv
  - COURSE/scripts/viridis.R

### Aims

- Practice joining data sets
- Practice reshaping data with `pivot_longer()` and `pivot_wider()`
- Review data visualization and transformations





### Obesity and Education Background

We are interested in examining a relationship between obesity and educational level.

The education data set in the file *education.csv* summarizes education level in Wisconsin by zip code and sex with the percentage of men and women age 25 and older who have a bachelor's degree or higher.
There is one row per zip code and separate columns for females and males with a small amount of missing data.

The obesity data is broken down more finely: we have one row for each zip code, sex, and age range.

In order to join these data sets, we will want to reshape each so that there is one row per zip code and sex.
The reshaped education data set will have columns `zip`, `sex`, and `pct_bachelors` with the percentage of individuals aged 25 and older of the given sex in that zip code with at least a bachelors degree.
The reshaped obesity data set will have columns `zip`, `sex` and `pct_obese` with the estimated population percentage of adult individuals in the given sex and zip code that are obese (BMI > 30).
We will only estimate these percentages in zip codes with no missing data among adults.

**Note that our adult educational variable and adult obesity variables are calculated on different subsets of the adult populations within each zip code and sex (25+ for education, 18+ for obesity). This is okay as our comparisons are at the zip code level and not the individual person level.**

The first few problems involve exploring and reshaping the individual data sets.
Later problems ask you to do some data analysis with these reshaped and/or joined data sets.

### Problems

  1a. Write code to read in the `education.csv` file into a data frame named `education_orig`. You should have a data frame with 776 rows and three columns named `zip`, `pct_m_bach`, and `pct_f_bach`.
  
```{r}
education_orig = read_csv("../../data/education.csv")
```
  
  
  1b. The next R chunk makes a summary calculation and prints it. Explain what each value represents.

```{r}
education_orig %>% 
  drop_na() %>% 
  summarize(num = sum(pct_f_bach > pct_m_bach),
            n = n(),
            p_1 = mean(pct_f_bach > pct_m_bach),
            p_2 = mean(pct_f_bach == pct_m_bach))
```

  

> `num` is 596, which means that number of zipcodes where women are more educated than men.

> `n` is 773, which means the number of zipcodes.

> `p_1` is 0.771022, which means the percentage of women who hold a bachelor's degree or higher more than men.

> `p_2` is 0.02069858, which means the percentage of same number of women as men with a bachelor's degree or higher.






  2a. Using the `education_orig` data set, create a scatter plot with `pct_f_bach` on the x axis and `pct_m_bach` on the y axis. There will be one point for each zip code.
Add to this plot a smooth curve colored blue which summarizes the trend in this plotted data.
Add an additional straight line colored red with slope 1 and intercept 0. Points on this line are zip codes where the percentage of females and males with at least a bachelors degree are equal. Then respond to the following questions.
Add meaningful axis labels and a plot title.

```{r}
ggplot(education_orig, aes(x=pct_f_bach, y=pct_m_bach)) + 
  geom_point() + geom_smooth(color="blue", se=TRUE) + 
  geom_abline(intercept = 0, slope = 1, color = "red") + 
  xlab("Percentage of females with a bachelor's degree or higher") +
  ylab("Percentage of males with a bachelor's degree or higher") +
  ggtitle("Relationship between the Percentage of Males and Females with a Bachelor's Degree or Higher by Zip Code")
```

  2b. Describe what the pattern in the plot says about the relationship between female and male educational levels (as measured by the percentage of adults aged 25 and older with bachelor's degrees) among the various zip codes in Wisconsin.

> Wisconsin residents generally have low levels of education per capita, with female slightly more educated than male.

  2c. What do you think might be true about the zip codes with strong outliers, for example, where percentages are 0% or 100%?

> I think it may be due to the small number of these samples collected.
  








  3a. Create a data frame named `education` in *long* format with 
a single row for each zip code and sex combination (so, two rows per zip code, one for females and one for males) using the `pivot_longer()` function.
Prior to pivoting, drop rows with any missing data.
Arrange the rows of the data set by zip code and sex.
After the transformation, you should have the following columns:

- `zip` = zip code; *change its type to character*
- `sex` = sex; make the values `"female"` and `"male"`
- `pct_bachelors` = % adults (aged 25+, of the given sex by zip) with at least a bachelors degree.

  3 (cont). 

This data transformation will require reshaping data, changing data values, and transforming column names.
There are (at least) two ways to think about doing this:

- `rename()` the columns before reshaping.
- `recode()` the values after reshaping.

Pick one and do it.

```{r}
education_3a = education_orig %>%
  drop_na() %>%
  rename(male = pct_m_bach, female = pct_f_bach) %>%
  mutate(zip=as.character(zip)) %>%
  pivot_longer(cols=c("female", "male"), names_to="sex", values_to="pct_bachelors")
```

  3b. Print out all columns of the first ten rows of the transformed education data frame.

```{r}
education_3a %>% 
  head(n=10, width=Inf)
```






  4. Read in the obesity data set from the file *obesity.csv*.
  
- Convert `zip` to be character type.
  
- As in the lecture notes, add columns `obese_pop` and `non_obese_pop` which contain estimates of the number of obese individuals within the population by each row (each zip/sex/age combination).

- Create a summary of the data named `adult_pop_sum` with one row for each zip code and sex combination with a variable `total_pop` which contains the total population of all adult men and women for each zip code (age 18 and older).

- Display this data with side-by-side box-plots of the data with the total population for each zip code on the x axis and sex on the y axis, adding appropriate axis labels and a title.

```{r}
obesity_data = read_csv("../../data/obesity.csv") %>% 
  mutate(zip = as.character(zip))

u=obesity_data %>%
  group_by(zip, sex, age) %>%
  mutate(obese_pop = sum(obese), non_obese_pop = sum(pop) - sum(obese)) %>%
  ungroup()
  
adult_pop_sum = u %>%
  filter(age >= 18) %>%
  group_by(zip, sex) %>%
  summarise(total_pop = sum(pop))

adult_pop_sum
```

```{R}
ggplot(adult_pop_sum, aes(x = total_pop, y = sex)) +
  geom_boxplot(color="mediumorchid4") + labs(x = "Zip Code", y = "Sex", title = "Distribution of Total Population by Zip Code and Sex")
```



  5a. The `education` data set from Problem 3 and the `adult_pop_sum` data set from Problem 4 each have one row per zip code and sex combination.
  
- Join these data sets together to add the `total_pop` column data from `adult_sum_pop` to add a new variable to the `education` data set.

- Next, print out all rows where the percentage of individuals with a college degree is 0% or 100% and arrange in descending order of population.



```{r}
education_5a = left_join(education_3a, adult_pop_sum) %>%
  filter(pct_bachelors == 0 | pct_bachelors == 100) %>%
  arrange(desc(total_pop))

education_5a
```

  5b. What seems interesting about this table?

> In the area with zip code 53706, the number of highly educated people exceeds expectations, indicating that this must be a college town similar to Madison.








  6. Use the newly joined `education` data set to estimate the percentage of women and men in the state with at least a bachelors degree.
Report these percentages.
(*Note: You will want to determine the number of individuals for each zip code and sex with a bachelors degree before summing to get totals by sex for the whole state. You may ignore the detail that population totals are age 18+ and education level is for age 25+. You also should delete zip codes with missing education data prior to summing over zip codes for this calculation, but do not delete these rows from the education data set. Ensure that the `zip` variable is type character in both data sets before joining them. In addition, when using `group_by()` with multiple variables, all variables but the last are retained as grouping variables after `summarize()`. You may need to pipe a data set through `ungroup()` to eliminate residual grouping on occasion.*)

```{r}
education_6 = left_join(education_3a, adult_pop_sum) %>%
  drop_na() %>%
  mutate(bachelors_pop = total_pop * (pct_bachelors/100)) %>%
  group_by(sex) %>%
  summarize(total_pop=sum(total_pop), bachelors_pop=sum(bachelors_pop)) %>%
  mutate(pct_bachelors=(bachelors_pop/total_pop)) %>%
  ungroup()
education_6
```

> The percentages of women and men ages 25 and older in Wisconsin with a bachelors degree are 0.2984488 and 0.2745920





  7. Create a summary of the obesity data named `adult_obesity_sum` which contains one row for each zip code and sex with counts of the number of obese individuals (`obese_pop`) and the total population (`total_pop`) of adults age 18+ by zip code and sex. *Only include zip codes with no missing data for all eight adult age groups.*
  
- Specifically, filter out the rows with ages 5-17, filter out rows with any missing obesity data, add a variable which counts the number of remaining rows for each zip code, and filter out rows where this count is less than 8. Once you have completed filtering out zip codes that do not have complete obesity data for all adult age groups, then, you may sum the total number of obese individuals ans the total population for each remaining zip code.

- If you have done this correctly, there are 306 zip codes with complete adult obesity data, so your obesity data set has $306 \times 2 = 612$ rows.

- Print the first ten rows of this data set.

```{r}
adult_obesity_sum = obesity_data %>%
  filter(age != "05-17") %>%
  drop_na() %>%
  group_by(zip) %>%
  mutate(zips=n()) %>%
  filter(zips>=8) %>%
  group_by(zip, sex) %>%
  summarize(obese_pop=sum(pop*(obese/n)), total_pop = sum(sum(obese) + sum(pop)- sum(obese)))

adult_obesity_sum %>%
  head(adult_obesity_sum, n = 10)
```


  8. Join the `adult_obesity_sum` and the `education` data sets, joining by zip code and sex,
keeping only zip code / sex combinations found in both data sets.
(Use `by = c("zip", "sex")` to specify more than one joining variable.) Add a variable `pct_obese` which contains the percentage of obese individuals per zip code/sex.

- Using this data set, create a scatter plot with the obesity percentage on the y-axis versus the education percentage on the x axis.
Use different colors for each sex and add a smooth curve for each sex.
Describe the pattern you see:
how does obesity rate change among men and women as education percentage increases?

```{r}
education_8 = inner_join(adult_obesity_sum, education_3a, by=c("zip", "sex")) %>%
  mutate(pct_obese=(obese_pop/total_pop)*100)

ggplot(education_8, aes(x=pct_bachelors, y=pct_obese, color=sex)) + 
  geom_point() + geom_smooth(se=TRUE) + labs(x="Obesity Percentage", y="Bachelors Percentage", title="Relationship between the Percentage of Obesity and Bachelors") + scale_color_manual(values=c("firebrick1", "darkslategrey"))
```


