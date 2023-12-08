library(tidyverse)
library(dplyr)
library(readr)
library(sf)
library(recipes)
library(tidymodels)
library(broom)
library(patchwork)
library(ggplot2)
library(tidyclust)
library(Rfast)

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
  select(less_than_hs_percent, GEO_ID)%>%
  mutate(GEOID = sub("1400000US","",GEO_ID))

join_data2 <- left_join(x= geospatial_data, hs_tract, by = "GEOID")


ed_plot <- ggplot(st_as_sf(join_data2)) + 
  geom_sf(aes(fill = less_than_hs_percent)) +
  scale_fill_gradient(high = "red", low = "green") +
  coord_sf()

library(patchwork)
plot_together = broadband_plot + ed_plot

plot_together

#MACHINE LEARNING
#prep the data

ed_percent_rec <- recipe(percent_broadband ~ . data = ed_census_inc_percent_tract)

set.seed(20201007)

# create a split object
data_split <- initial_split(data = ed_census_inc_percent_tract, prop = 0.75)

# create the training and testing data
data_train <- training(x = data_split)
data_test <- testing(x = data_split)

# create a recipe
knn_rec <-
  recipe(formula =, data = data1_train)

# create a knn model specification
knn_mod <-
  nearest_neighbor(neighbors = 5) %>%
  set_engine(engine = "kknn") %>%
  set_mode(mode = "regression")

# create a workflow
knn_wf <-
  workflow() %>%
  add_recipe(knn_rec) %>%
  add_model(knn_mod)

# fit the knn model specification on the training data
knn_fit <- knn_wf %>%
  fit(data = data1_train)

# use the estimated model to predict values in the testing data
predictions <-
  bind_cols(
    data_test,
    predict(object = knn_fit, new_data = data_test)
    )

# calculate the rmse on the testing data
rmse(data = predictions, truth = percent_broadband, estimate = .pred)