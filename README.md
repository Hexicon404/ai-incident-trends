# AI Incident Trends: From Accidents to Misuse

**Author:** Abhiyankar Sindhu  
**Research Question:** Since 2015, has the balance of reported AI incidents shifted from AI systems failing by accident towards people deliberately misusing AI, and which types of harm drove the change?

## Project Overview

This project analyses the AI Incident Database (AIID) using the CRISP-DM framework to evaluate how the proportion of intentional versus unintentional AI harm has changed between 2015–2021 and 2022–2025, with findings written for policy leads at the UK AI Security Institute.

## Repository Structure

```text
ai-incident-trends/
├── ai-incident-trends.Rproj   # RStudio project file (sets working directory)
├── .Rprofile                  # R profile script for renv initialization
├── renv.lock                  # Lockfile recording R package dependencies
├── .gitignore                 # Excludes raw data/ folder and renv library from GitHub
├── README.md                  # Project overview and reproduction guide
├── notes.md                   # Live decision log and demo notes
├── report.qmd                 # Quarto source document (6 CRISP-DM sections)
├── report.html                # Rendered standalone HTML report
├── renv/                      # Project-specific R environment files
├── R/
│   ├── 01-load-data.R         # Reads Excel file, selects columns, checks missingness
│   └── 02-data-cleaning.R     # Filters years/classifications, builds summary tables
└── data/
    └── AIID_Excel_Export.xlsx # Raw AIID spreadsheet export from Canvas
```

## How to Run and Reproduce the Report

1. **Software Requirements:** R (version 4.3 or higher recommended), RStudio, and Quarto (bundled with recent versions of RStudio).
2. **Restore Package Environment:** This project uses `renv` for dependency management. Open `ai-incident-trends.Rproj` in RStudio and run the following in the Console to install the exact package versions used:
   ```r
   renv::restore()
   ```
3. **Data Placement:** Ensure the Canvas dataset `AIID_Excel_Export.xlsx` is placed inside the `data/` directory (`data/AIID_Excel_Export.xlsx`). Note that `.gitignore` keeps `data/` off GitHub, but the folder is included in the submitted project `.zip` archive.
4. **Render the Report:**
   - Open `report.qmd` and click **Render** (or run `quarto::quarto_render("report.qmd")` in the Console).
   - Running `report.qmd` automatically sources `R/01-load-data.R` and `R/02-data-cleaning.R` and produces `report.html`.

## Data Source

- **Source:** AI Incident Database (Responsible AI Collaborative), augmented with the MIT AI Risk Repository taxonomy (`Intent`, `Risk Domain`, and `Risk Subdomain`).
- **URL:** <https://incidentdatabase.ai/>
- **Snapshot:** Canvas course export (`AIID_Excel_Export.xlsx`, 1,734 incidents across 59 columns).
