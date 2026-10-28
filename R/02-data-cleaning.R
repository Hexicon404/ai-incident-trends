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


# calculate yearly share of Intentional vs Unintentional incidents
yearly_intent <- incidents_clean |>
  count(year, intent, name = "n") |>
  group_by(year) |>
  mutate(
    total_year = sum(n),
    share = round((n / total_year) * 100, 1)
  ) |>
  ungroup()

# pull intentional shares for specific years to use in inline report text
yearly_intentional_only <- yearly_intent |>
  filter(intent == "Intentional")

pct_intent_2015 <- yearly_intentional_only |>
  filter(year == 2015) |>
  pull(share)

pct_intent_2021 <- yearly_intentional_only |>
  filter(year == 2021) |>
  pull(share)

pct_intent_2022 <- yearly_intentional_only |>
  filter(year == 2022) |>
  pull(share)

pct_intent_2023 <- yearly_intentional_only |>
  filter(year == 2023) |>
  pull(share)

pct_intent_2025 <- yearly_intentional_only |>
  filter(year == 2025) |>
  pull(share)

# summarise counts and intentional share across the two periods
period_intent_summary <- incidents_clean |>
  count(period, intent, name = "n") |>
  group_by(period) |>
  mutate(
    Total_Classified = sum(n),
    Share_Pct = round((n / Total_Classified) * 100, 1)
  ) |>
  ungroup()

period_intent_table <- period_intent_summary |>
  filter(intent == "Intentional") |>
  mutate(
    Unintentional_Count = Total_Classified - n
  ) |>
  select(
    Period = period,
    `Classified Incidents` = Total_Classified,
    `Intentional Incidents` = n,
    `Unintentional Incidents` = Unintentional_Count,
    `Intentional Share (%)` = Share_Pct
  )

pct_intent_pre2022 <- period_intent_table$`Intentional Share (%)`[1]
pct_intent_post2022 <- period_intent_table$`Intentional Share (%)`[2]
diff_intent_pp <- round(pct_intent_post2022 - pct_intent_pre2022, 1)



# calculate Risk Domain shares within each period
domain_period_summary <- incidents_clean |>
  count(period, risk_domain_short, name = "n") |>
  group_by(period) |>
  mutate(
    share = round((n / sum(n)) * 100, 1)
  ) |>
  ungroup()

# pull pre-2022 and post-2022 shares for top domains for inline text
pct_misuse_pre2022 <- domain_period_summary |>
  filter(
    period == "2015-2021 (Pre-2022)",
    risk_domain_short == "Malicious Actors & Misuse"
  ) |>
  pull(share)

pct_misuse_post2022 <- domain_period_summary |>
  filter(
    period == "2022-2025 (2022 Onwards)",
    risk_domain_short == "Malicious Actors & Misuse"
  ) |>
  pull(share)

diff_misuse_pp <- round(pct_misuse_post2022 - pct_misuse_pre2022, 1)

pct_safety_pre2022 <- domain_period_summary |>
  filter(
    period == "2015-2021 (Pre-2022)",
    risk_domain_short == "System Safety & Failures"
  ) |>
  pull(share)

pct_safety_post2022 <- domain_period_summary |>
  filter(
    period == "2022-2025 (2022 Onwards)",
    risk_domain_short == "System Safety & Failures"
  ) |>
  pull(share)

pct_discrim_pre2022 <- domain_period_summary |>
  filter(
    period == "2015-2021 (Pre-2022)",
    risk_domain_short == "Discrimination & Toxicity"
  ) |>
  pull(share)

pct_discrim_post2022 <- domain_period_summary |>
  filter(
    period == "2022-2025 (2022 Onwards)",
    risk_domain_short == "Discrimination & Toxicity"
  ) |>
  pull(share)

# break down Malicious Actors & Misuse by Risk Subdomain
misuse_subdomains <- incidents_clean |>
  filter(risk_domain == "Malicious Actors & Misuse") |>
  count(risk_subdomain, sort = TRUE, name = "Incidents") |>
  mutate(
    `Share of Misuse (%)` = round((Incidents / sum(Incidents)) * 100, 1)
  ) |>
  rename(`Risk Subdomain` = risk_subdomain)

top_misuse_subdomain <- misuse_subdomains$`Risk Subdomain`[1]
n_top_misuse_subdomain <- misuse_subdomains$Incidents[1]
n_total_misuse <- sum(misuse_subdomains$Incidents)
pct_top_misuse_subdomain <- misuse_subdomains$`Share of Misuse (%)`[1]

