# ######IGNORE THIS FILE FOR NOW
# 
# library(aider)
# library(tidyverse)
# library(readODS)
# library(lubridate)
# library(forecast)
# 
# aider::make_data_dir(project_name = "electronic-vehicles-forecast", data_path_root = "../../../data")
# 
# ##creating input and output directories inside the project
# dir.create("input")
# dir.create("output")
# 
# ##QUESTIONS:
# ## are the tables correct?
# ## UK only has data from 2014x
# ## for licensed vehicles, should we consider road using or all?
# 
# 
# ##downloading the data from "https://www.gov.uk/government/statistical-data-sets/vehicle-licensing-statistics-data-tables#all-vehicles"
# 
# #Download data from ONS site
# download_from_ons_function <- function(file_name, url, download_directory_ = download_directory){
#   
#   #Download file
#   download.file(
#     url,
#     paste0("input/", file_name),
#     method = "auto",
#     #Mode needs changing on Windows machines
#     #This allows it to download binary files correctly)
#     mode = "wb")
#   
# }
# 
# ##All vehicles has 2 categories : licensed vehicles and vehicles registered for the first time
# 
# ##Licensed vehicles at the end of the quarter by body type and fuel type: Great Britain and United Kingdom: VEH1103
# 
# download_from_ons_function("licensed_vehicles_fuel_and_body_type.ods", "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1077420/veh1103.ods")
# 
# all_licensed_vehicles_fuel_and_body_type <- read_ods("input/licensed_vehicles_fuel_and_body_type.ods", sheet = "VEH1103b_All", skip = 4)
# 
# uk_total_licensed_vehicles_quarterly <- all_licensed_vehicles_fuel_and_body_type %>%
#   filter(Geography == "United Kingdom") %>%
#   filter(BodyType == "Total") %>%
#   filter(Units == "Thousands")
# 
# download_from_ons_function("first_time_registered_vehicles_fuel_and_body_type.ods", "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1077488/veh1153.ods")
# 
# all_first_time_registered_vehicles_fuel_and_body_type <- read_ods("input/first_time_registered_vehicles_fuel_and_body_type.ods", sheet = "VEH1153b_All", skip = 4)
# 
# uk_total_first_time_registered_vehicles <- all_first_time_registered_vehicles_fuel_and_body_type %>%
#   filter(Geography == "United Kingdom") %>%
#   filter(BodyType == "Total") %>%
#   filter(Units == "Thousands")
# 
# 
# 
# ################
# 
# ##forecasting UK total registered  (all fuel types) till the year 2032
# 
# all_uk_registered_vehicles_total <- uk_total_licensed_vehicles_quarterly %>%
#   select(Date, Total)
# 
# all_uk_registered_vehicles_ts <- ts(as.numeric(all_uk_registered_vehicles_total[, 2]), frequency = 4)
# 
# plot(decompose(all_uk_registered_vehicles_ts))
# 
# start_date <- '2014-07-01'
# target_year <- 2032
# 
# forecast_length <- time_length(target_year - 2021) * 4 - quarter('2021-10-01')
# 
# all_uk_registered_vehicles_ts %>%
#   auto.arima() %>%
#   forecast(h = forecast_length) %>%
#   autoplot()
# 
# 
# glimpse(uk_total_licensed_vehicles_quarterly)
# 
# ### PHEV 
# ##getting only the PHEV data forecast
# 
# all_uk_registered_vehicles_phev <- uk_total_licensed_vehicles_quarterly %>%
#   select(Date, `Plug-in Hybrid Electric [note 3]`)
# 
# phev_uk_registered_vehicles_ts <- ts(as.numeric(all_uk_registered_vehicles_phev[, 2]), frequency = 4)
# 
# plot(decompose(phev_uk_registered_vehicles_ts))
# 
# start_date <- '2014-07-01'
# target_year <- 2032
# 
# forecast_length <- time_length(target_year - 2021) * 4 - quarter('2021-10-01')
# 
# phev_uk_registered_vehicles_ts %>%
#   auto.arima() %>%
#   forecast(h = forecast_length) %>%
#   autoplot()
# 
# 
# 
# ### BEV
# 
# 
# all_uk_registered_vehicles_bev <- uk_total_licensed_vehicles_quarterly %>%
#   select(Date, `Battery Electric`)
# 
# bev_uk_registered_vehicles_ts <- ts(as.numeric(all_uk_registered_vehicles_bev[, 2]), frequency = 4)
# 
# plot(decompose(bev_uk_registered_vehicles_ts))
# 
# start_date <- '2014-07-01'
# target_year <- 2032
# 
# forecast_length <- time_length(target_year - 2021) * 4 - quarter('2021-10-01')
# 
# bev_uk_registered_vehicles_ts %>%
#   auto.arima() %>%
#   forecast(h = forecast_length) %>%
#   autoplot()
