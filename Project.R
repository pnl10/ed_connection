library(tidyverse)
library(dplyr)
library(readr)
aps_educon <- read_csv("aps_educon.csv")

aps_educon <- aps_educon %>%
  filter(YEAR > 2015)%>%
  select(-HIGRADE, -HIGRADED, -COUNTYICP, -REGION, -STATEFIP)


