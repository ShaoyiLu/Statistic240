## reset color defaults
## Source https://data-se.netlify.com/2018/12/12/changing-the-default-color-scheme-in-ggplot2/
library(viridisLite)

#### continuous variables color and fill
options(ggplot2.continuous.colour = "viridis")
options(ggplot2.continuous.fill = "viridis")

#### use viridis for discrete scales
scale_colour_discrete = scale_colour_viridis_d
scale_fill_discrete = scale_fill_viridis_d 
