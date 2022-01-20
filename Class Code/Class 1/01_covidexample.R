## Set the working directory
setwd("C:/Users/grif3/OneDrive/Desktop/ISA 444")

## Load the packages
library(COVID19)

pacman::p_load(tidyverse, #tidyverse -- IMO needed for most of your analysis
               tidyquant, #tidyquant -- to be used for getting stock data
               magrittr) #magrittr -- loading to use the pipe operators

## Inspect the covid19 function
?covid19
covidcases = covid19(country = "USA", level = 2, start = '2020-03-01')
covidcases = covidcases %>% filter(administrative_area_level_2 %in% c("Ohio", "Kentucky"))

## Build two plots of confirmed cases in Ohio and Kentucky
covidcases %>% 
  ggplot(mapping = aes(x = date, y = confirmed,
                       group = administrative_area_level_2,
                       color = administrative_area_level_2)) +
  geom_line() +
  facet_wrap(~ administrative_area_level_2, ncol = 2, scales = "free_y") +
  labs(x = "Date", y = "Confirmed Cases",
       caption = "Confirmed Cases of COVID-19 in Ohio and Kentucky from March 1, 2020 to Present") +
  theme_bw()
