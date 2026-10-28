# keep 2015-2025 only (before 2015 has too few rows per year, 2026 is incomplete)
incidents_years <- raw_incidents |>
  filter(
    year >= 2015,
    year <= 2025
  )

n_after_years <- nrow(incidents_years)
n_removed_years <- n_raw_rows - n_after_years

# drop rows missing MIT Intent or Risk Domain classifications
incidents_classified <- incidents_years |>
  filter(
    !is.na(intent),
    !is.na(risk_domain)
  )

n_after_classified <- nrow(incidents_classified)
n_removed_unclassified <- n_after_years - n_after_classified