library(aider)
library(tidyverse)
library(readODS)
library(lubridate)
library(forecast)
library(janitor)
library(readxl)
library(zoo)
library(stringr)
library(ggplot2)


source("functions.R")

aider::make_data_dir(project_name = "electronic-vehicles-forecast", data_path_root = "../../../data")

##creating input and output directories inside the project
dir.create("input")
dir.create("output")

##importing Umar's ev forecast

ev_market_2023_budget <- read_excel("input/EV_Market_Maths.xlsx")
##TODO: clean up this data so that it can be compared


##Sourcing the carpark data from ONS : licensed vehicles from ONS

##Licensed vehicles at the end of the quarter by body type and fuel type: Great Britain and United Kingdom: VEH1103

download_from_ons_function("licensed_vehicles_fuel_and_body_type.ods", "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1077420/veh1103.ods")

all_licensed_vehicles_fuel_and_body_type <- read_ods("input/licensed_vehicles_fuel_and_body_type.ods", sheet = "VEH1103b_All", skip = 4)

##only licensed car data from United Kingdom
all_licensed_vehicles_fuel_and_body_type_cleaned <- all_licensed_vehicles_fuel_and_body_type %>%
  janitor::clean_names() %>%
  filter(geography == "United Kingdom") %>%
  filter(body_type == "Cars") %>%
  filter(units == "Thousands") %>%
  mutate(
    newest_date = convert_to_date_format(date),
    battery = battery_electric,
    hybrid = hybrid_electric_petrol + hybrid_electric_diesel,
    mild_hybrid = fuel_cell_electric,
    plugin_hybrid = plug_in_hybrid_electric_petrol + plug_in_hybrid_electric_diesel + range_extended_electric
    ) %>%
  select(date, newest_date, units, battery, hybrid, mild_hybrid, plugin_hybrid, total)
##fuel cell electric are mild hybrid electric, generally classed as alternative fuel vehicle 

write.csv(all_licensed_vehicles_fuel_and_body_type_cleaned,"output/all_ev_data.csv", row.names = FALSE)

##Plotting to see trend: all cars, bev and phev

ggplot(all_licensed_vehicles_fuel_and_body_type_cleaned, aes(x=newest_date)) +
  geom_line(aes(y = battery), color = "darkred") + 
  geom_line(aes(y = plugin_hybrid), color="steelblue", linetype="twodash") +
  labs(title = "Car park data for United Kingdom", x = "Year", y = "Licensed cars (in Thousands)", caption = "Licensed cars in the UK")

##Forecast: using the arima model, using the carpark data for BEV and PHEV

### ------------------------------BEV

start_date <- '2015-01-01' ## starting from the first quarter of 2015
target_year <- 2033

uk_licensed_bev_cars <- all_licensed_vehicles_fuel_and_body_type_cleaned %>%
  filter(newest_date >= start_date) %>%
  select(newest_date, 
         battery)


bev_uk_registered_vehicles_ts <- ts(as.numeric(uk_licensed_bev_cars[, 2]), frequency = 4)

plot(decompose(bev_uk_registered_vehicles_ts))

forecast_length <- time_length(target_year - year(max(uk_licensed_bev_cars$newest_date))) * 4 - quarter(max(uk_licensed_bev_cars$newest_date))

bev_uk_registered_vehicles_ts %>%
  auto.arima() %>%
  forecast(h = forecast_length) %>%
  autoplot()

bev_cars_quarterly_forecast <- rownames_to_column(
  data.frame(
    bev_uk_registered_vehicles_ts %>% 
      auto.arima() %>% 
      forecast(h = forecast_length),
    stringsAsFactors = FALSE), var = "quarter") %>%
  mutate(id = word(
    str_trim(quarter, "left"), 1, sep = " "),
    quarter = word(
      str_trim(quarter, "left"), 2, sep = " ")) %>%
  mutate(year = case_when(
    id == 8 ~ 2022,
    id == 9 ~ 2023,
    id == 10 ~ 2024,
    id == 11 ~ 2025,
    id == 12 ~ 2026,
    id == 13 ~ 2027,
    id == 14 ~ 2028,
    id == 15 ~ 2029,
    id == 16 ~ 2030,
    id == 17 ~ 2031,
    id == 18 ~ 2032,
    id == 19 ~ 2033))%>%
  mutate(date = convert_quarterly_data_to_iso(paste0(year, " ", quarter)),
         type = "forecast") %>%
  rename(battery = Point.Forecast,
         battery_low_95 = Lo.95,
         battery_high_95 = Hi.95
         ) %>%
  select(date, battery, battery_low_95,battery_high_95, type) 

write.csv(bev_cars_quarterly_forecast,"output/bev_forecast.csv", row.names = FALSE)

### -------------------------------PHEV 
##getting only the PHEV data forecast

uk_licensed_phev_cars <- all_licensed_vehicles_fuel_and_body_type_cleaned %>%
  filter(newest_date >= start_date) %>%
  select(newest_date, 
         plugin_hybrid)


phev_uk_registered_vehicles_ts <- ts(as.numeric(uk_licensed_phev_cars[, 2]), frequency = 4)

plot(decompose(phev_uk_registered_vehicles_ts))

forecast_length <- time_length(target_year - year(max(uk_licensed_phev_cars$newest_date))) * 4 - quarter(max(uk_licensed_phev_cars$newest_date))

phev_uk_registered_vehicles_ts %>%
  auto.arima() %>%
  forecast(h = forecast_length) %>%
  autoplot()

phev_cars_quarterly_forecast <- rownames_to_column(
  data.frame(
    phev_uk_registered_vehicles_ts %>% 
      auto.arima() %>% 
      forecast(h = forecast_length),
    stringsAsFactors = FALSE), var = "quarter") %>%
  mutate(id = word(
    str_trim(quarter, "left"), 1, sep = " "),
    quarter = word(
      str_trim(quarter, "left"), 2, sep = " ")) %>%
  mutate(year = case_when(
    id == 8 ~ 2022,
    id == 9 ~ 2023,
    id == 10 ~ 2024,
    id == 11 ~ 2025,
    id == 12 ~ 2026,
    id == 13 ~ 2027,
    id == 14 ~ 2028,
    id == 15 ~ 2029,
    id == 16 ~ 2030,
    id == 17 ~ 2031,
    id == 18 ~ 2032,
    id == 19 ~ 2033))%>%
  mutate(date = convert_quarterly_data_to_iso(paste0(year, " ", quarter)),
         type = "forecast") %>%
  rename(plugin_hybrid = Point.Forecast,
         plugin_hybrid_low_95 = Lo.95,
         plugin_hybrid_high_95 = Hi.95) %>%
  select(date, plugin_hybrid,plugin_hybrid_low_95, plugin_hybrid_high_95,type) 

write.csv(phev_cars_quarterly_forecast,"output/phev_forecast.csv", row.names = FALSE)

###-------------------------------PLOTTING BEV AND PHEV FORECAST

combined_forecast_bev_phev = merge(bev_cars_quarterly_forecast, phev_cars_quarterly_forecast)

ggplot(combined_forecast_bev_phev, aes(x=date)) +
  geom_line(aes(y = battery), color = "darkred") + 
  geom_line(aes(y = plugin_hybrid), color="steelblue", linetype="twodash") +
  labs(title = "Forecast car park data for United Kingdom", x = "Year", y = "Licensed cars (in Thousands)", caption = "EV forecast for licensed cars in the UK")
