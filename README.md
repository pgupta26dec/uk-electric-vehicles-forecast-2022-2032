# UK Electric Vehicles Forecast (2022-2032)

A comprehensive data science project that analyzes and forecasts the adoption of Electric Vehicles (EVs) in the United Kingdom. This project utilizes official government "car park" data to project growth trends for Battery Electric Vehicles (BEVs) and Plug-in Hybrids (PHEVs) through 2033 using ARIMA time-series modeling.

## 📊 Project Overview

As the UK moves toward its 2030/2035 electrification targets, understanding the trajectory of "cars on the road" (the car park) is essential. This project automates the ingestion of licensed vehicle data from the Department for Transport (DfT) and applies statistical forecasting to predict future fleet volumes.

### Key Features
* **Automated Data Retrieval:** Functions to download and process the latest `VEH1103` ODS files from GOV.UK.
* **Data Cleaning & Categorization:** Standardizes disparate fuel types into clean categories (Battery, Hybrid, Plug-in Hybrid, Mild Hybrid).
* **Time-Series Analysis:** Employs the **ARIMA (AutoRegressive Integrated Moving Average)** model to generate quarterly forecasts.
* **Professional Reporting:** Includes integrated presentation and spreadsheet outputs for stakeholders.

## 🛠 Tech Stack

* **Language:** R
* **Data Manipulation:** `tidyverse`, `janitor`, `lubridate`, `readODS`, `readxl`, `zoo`
* **Forecasting:** `forecast` (ARIMA modeling)
* **Visualization:** `ggplot2`
* **Workflow:** `aider`

## 📂 Project Structure

```text
├── electric_vehicles_forecast.R    # Primary execution script for modeling
├── extract_vehicle_data.R          # Script for fetching and cleaning ONS/DfT data
├── functions.R                     # Helper functions for date formatting and API downloads
├── electronic-vehicles-forecast.Rproj # RProject configuration file
├── EV forecast 2022-2032.pptx      # Presentation of findings and forecast results
├── EV forecast.xlsx                # Detailed data tables and calculations
├── input/                          # Raw data directory (Auto-generated)
├── output/                         # Processed CSVs and forecast results (Auto-generated)
└── README.md
