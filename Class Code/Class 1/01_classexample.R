## Set the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## Checking to see whether the pacman package is installed
if(require(pacman) == FALSE) install.packages("pacman")

pacman::p_load(tidyverse, #tidyverse -- IMO needed for most of your analysis
               tidyquant, #tidyquant -- to be used for getting stock data
               magrittr) #magrittr -- loading to use the pipe operators

## Create an object and get our data
FANG = tq_get(x = c('AMZN', 'FB', 'GOOG', 'NFLX'), #stocks that we want
              from = '2020-01-01', #gets this date or the next trading date
              to = '2021-01-23') #gets data up to but not including the date
str(FANG) #returns the object's internal structure

max(FANG$date)

## Let's build the plot
FANG %>% #layer 1: data (which gets passed for the first argument via the pipe)
  ggplot(mapping = aes(x = date, y = adjusted, group = symbol, color = symbol)) + #layer 2: aesthetics
  geom_line() + #layer 3
  facet_wrap(~ symbol, ncol = 2, scales = 'free_y') + #layer 4: facets
  stat_smooth(method = 'loess') + #layer 5: fitting a local regression (optional)
  labs(x = 'Date', y = 'Adjusted Closing Price',
       caption = 'Data from 2020-01-02 to 2021-01-22') +
  theme_bw()

## Getting the starting date
FANG %>% 
  filter(date == '2020-01-02') %>%  #filter comes from dplyr, a row wise operation
  select(symbol, adjusted) -> #select is a column wise operation
  baseFANG

## Getting the ending date
FANG %>% 
  filter(date == '2021-01-22') %>%  #filter comes from dplyr, a row wise operation
  select(symbol, adjusted) -> #select is a column wise operation
  currentFANG

## Combine them into one
combinedFANG = left_join(x = baseFANG,
                         y = currentFANG,
                         by = 'symbol') #also comes from dplyr/tidyverse

## Change the column names
colnames(combinedFANG)[2:3] = c('base', 'current')

## Calculate the percent change
combinedFANG$pctChange = 100 * (combinedFANG$current - combinedFANG$base)/combinedFANG$base
