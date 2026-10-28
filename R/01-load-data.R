# Load packages needed for data wrangling, Excel import, and tables
library(tidyverse)
library(readxl)
library(knitr)

# Skip the first 2 metadata rows so row 3 becomes the column header
aiid_full <- read_xlsx(
  "data/AIID_Excel_Export.xlsx",
  sheet = 1,
  skip = 2
)

# Store raw dataset dimensions and year range for inline report text
n_raw_rows <- nrow(aiid_full)
n_raw_cols <- ncol(aiid_full)
min_raw_year <- min(aiid_full$year, na.rm = TRUE)
max_raw_year <- max(aiid_full$year, na.rm = TRUE)

# Keep only the 8 columns needed to answer the research question
raw_incidents <- aiid_full |>
  select(
    incident_id = `Incident ID`,
    year,
    title,
    report_count,
    risk_domain = `Risk Domain`,
    risk_subdomain = `Risk Subdomain`,
    responsible_entity = `Responsible Entity`,
    intent = Intent
  )

# Count missing values across selected columns to check data completeness
missing_summary <- raw_incidents |>
  summarise(
    across(
      everything(),
      ~ sum(is.na(.x))
    )
  ) |>
  pivot_longer(
    cols = everything(),
    names_to = "Column",
    values_to = "Missing_Count"
  ) |>
  mutate(
    Missing_Percent = round((Missing_Count / n_raw_rows) * 100, 1)
  )

# Count yearly totals across the entire database to show reporting volume over time
yearly_all_counts <- raw_incidents |>
  count(year, name = "incidents")


    
