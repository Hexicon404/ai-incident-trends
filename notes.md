# Project Log & Working Notes

## 1. Dataset Selection
- Looked at the other canvas datasets but AIID was the best fit. The MIT taxonomy is already attached (Intent and Risk Domain) so it saves me having to manually classify them.
- Thought about doing human vs AI blame, but checking a time trend (accidents vs misuse) makes way more sense for a real-world policy brief. The UK AI Security Institute actually needs to know where to put their money right now.

## 2. Data Cleaning Decisions (R/01 and R/02)
- Used `skip = 2` on `read_xlsx` because the first two rows in the raw file are just decorative headers.
- Subset to 8 core columns. The raw file has 59 columns but most of them are sparse technical fields. Better to drop them to keep memory clean on my Mac.
- **Year filter (2015-2025):** Dropped pre-2015 because it only has 1-5 incidents a year (one event swings the whole percentage). Dropped 2026 because the year isn't over yet and it makes the chart look like volume crashed.
- **Dropped NAs:** Around 238 rows are missing MIT labels, mostly in 2025. Didn't want to keep an "Unclassified" category because it messes up the denominator for the intentional vs unintentional math. Assuming the 2025 tagging backlog has the same intent split as the ones already tagged.
- **Period split (2022):** Split at 2022 because that's when generative AI (ChatGPT, Midjourney) went public.

## 3. Findings so far
- Had to use % shares instead of raw counts. Total reporting went crazy after 2022. If I used raw counts, every single category would just look like an upward line.
- The shift is massive: pre-2022, unintentional accidents were ~70-80% of the data. By 2025, intentional misuse took over at 65%.
- "Malicious Actors & Misuse" drove almost all of this.
- Inside that misuse domain, ~73% (412 out of 565) is just "Fraud, scams, and targeted manipulation" (deepfakes, voice clones).

## 4. Final Review & Limitations
- Overall the pipeline works. The biggest flaw is media bias. AIID relies on news reports, and journalists care way more about a celebrity deepfake scam than a boring hiring algorithm glitch. 
- If I had more time to iterate, I'd stratify by `report_count` to see if low-media incidents follow the same trend as the viral ones.