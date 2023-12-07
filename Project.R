library(tidyverse)
library(dplyr)
library(readr)
library(sf)
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

ed_census_inc_percent_tract <- ed_census_inc_percent_tract %>%
  mutate(GEOID = GEO_ID)%>%
  select(-GEO_ID)

plot1 <- ggplot(data = ed_census_inc_percent_tract,
  aes(x =  income, y= percent_broadband))+
  geom_point()+
  theme_minimal()

plot1


geospatial_data <- st_read("cb_2022_54_tract_500k", quiet = TRUE)

geospatial_data<- geospatial_data %>%
  select(GEOID, geometry)
broadband_tract <- ed_census_inc_percent_tract %>%
  select(percent_broadband, GEOID)%>%
  mutate(GEOID = sub("1400000US","",GEOID))

join_data <- left_join(x= geospatial_data, broadband_tract, by = "GEOID")


broadband_plot <- ggplot(st_as_sf(join_data)) + 
  geom_sf(aes(fill = percent_broadband)) +
  scale_fill_gradient(high = "blue", low = "orange") +
  coord_sf()

ed_census_inc_percent_tract <- ed_census_inc %>%
  mutate(less_than_hs_percent = less_than_hs / Pop_18.24)

hs_tract <- ed_census_inc_percent_tract %>%
  select(less_than_hs_percent, GEOID)%>%
  mutate(GEOID = sub("1400000US","",GEOID))

join_data2 <- left_join(x= geospatial_data, hs_tract, by = "GEOID")


ed_plot <- ggplot(st_as_sf(join_data2)) + 
  geom_sf(aes(fill = less_than_hs_percent)) +
  scale_fill_gradient(high = "red", low = "green") +
  coord_sf()

library(patchwork)
plot_together = broadband_plot + ed_plot

plot_together
