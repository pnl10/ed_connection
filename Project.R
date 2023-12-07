library(tidyverse)
library(dplyr)
library(readr)
income_data<- read_csv("income.csv")

census_data <- read.csv("census_data.csv")

ed_data <- read.csv("ed_data.csv")

urban_institute_data <- read.csv("urban_institute_data.csv")


ed_census_inc <- left_join(income_data, census_data, by = "GEO_ID")
ed_census_inc <- left_join(ed_census_inc, ed_data, by = "GEO_ID")


ed_census_inc <- ed_census_inc %>%
  select(-Area_Name.x)%>%
  select(-Area_Name.y)

ed_census_inc_percent_tract <- ed_census_inc %>%
  mutate(percent_broadband = Broadband.of.any.type..estimate / Pop_18.24)

ed_census_inc_percent_tract <- ed_census_inc_percent_tract %>%
  filter(startsWith(Geographic.Area.Name, "Census Tract"))


plot1 <- ggplot(data = ed_census_inc_percent_tract,
  aes(x =  income, y= percent_broadband))+
  geom_point()+
  theme_minimal()

plot1
