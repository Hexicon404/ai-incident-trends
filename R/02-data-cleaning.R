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

# drop 'Other' intent so comparison is strictly Intentional vs Unintentional
incidents_clean <- incidents_classified |>
  filter(
    intent %in% c("Intentional", "Unintentional")
  ) |>
  mutate(
    period = ifelse(
      year < 2022,
      "2015-2021 (Pre-2022)",
      "2022-2025 (2022 Onwards)"
    ),
    period = factor(
      period,
      levels = c("2015-2021 (Pre-2022)", "2022-2025 (2022 Onwards)")
    ),
    intent = factor(
      intent,
      levels = c("Intentional", "Unintentional")
    ),
    risk_domain_short = case_when(
      risk_domain == "AI system safety, failures, and limitations" ~ "System Safety & Failures",
      risk_domain == "Discrimination and Toxicity" ~ "Discrimination & Toxicity",
      risk_domain == "Socioeconomic & Environmental Harms" ~ "Socioeconomic & Environmental",
      TRUE ~ risk_domain
    ),
    risk_domain_short = factor(
      risk_domain_short,
      levels = c(
        "Malicious Actors & Misuse",
        "System Safety & Failures",
        "Discrimination & Toxicity",
        "Misinformation",
        "Privacy & Security",
        "Socioeconomic & Environmental",
        "Human-Computer Interaction"
      )
    )
  )

n_clean_rows <- nrow(incidents_clean)
n_removed_other <- n_after_classified - n_clean_rows
pct_retained <- round((n_clean_rows / n_raw_rows) * 100, 1)

