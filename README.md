# NHTS EV Ownership Analysis

A reproducible R analysis examining how household income, geographic region, and household size relate to electric vehicle (EV/PHEV) ownership in the United States, using National Household Travel Survey (NHTS) public-use data.


## Research Question

Is household EV/PHEV ownership associated with income bracket, region, or household size — and if so, which factor matters most?

## Data

- **Source:** NHTS public-use household file (`data-raw/hhv2pub.csv`) and vehicle file (`data-raw/vehv2pub.csv`).
- **Processing:** Raw household and vehicle records are cleaned and aggregated to the household level in `R/data_cleaning.R`, producing `data/nhts_analysis.rds`.
- **EV definition:** A household is coded `Has_EV = "Yes"` if it owns at least one electric or plug-in hybrid vehicle, based on vehicle-level fuel type records in the vehicle file.

## Methodology

For each of the three predictors (income bracket, region, household size), the analysis:

1. Builds a contingency table against EV/PHEV ownership.
2. Runs a chi-square test of independence.
3. Computes Cramér's V as an effect-size measure.
4. Computes standardized Pearson residuals to identify which specific groups are over- or under-represented among EV owners.

The full pipeline lives in `R/audit_functions.R` and `R/categorical_audit.R`, and is run end-to-end in `analysis.qmd`.

## Key Findings

| Predictor | χ² | df | p-value | Cramér's V |
|---|---|---|---|---|
| Income Bracket | 221.0 | 4 | < .001 | 0.168 |
| Region | 80.8 | 3 | < .001 | 0.102 |
| Household Size | 22.3 | 2 | < .001 | 0.054 |

Income has the strongest association with EV ownership: high-income households (>$150k) are substantially overrepresented among EV owners, while lower- and middle-income households are underrepresented. Region and household size show weaker, but still significant, associations.

See [`brief.md`](brief.md) for the full policy interpretation and discussion of limitations.

## Project Structure

```
NHTS_EV_Analysis/
├── R/
│   ├── audit_functions.R      # Chi-square + Cramér's V + residuals
│   ├── categorical_audit.R    # Runs the audit across all predictors
│   ├── data_cleaning.R        # Raw data cleaning and household aggregation
│   └── theme_decarb.R         # Shared ggplot theme for the heatmap
├── data-raw/                  # Raw NHTS household and vehicle files
├── data/                      # Cleaned, household-level analysis data
├── tests/testthat/            # Automated tests for the audit functions
├── analysis.qmd               # Full analysis notebook
├── brief.md                   # Policy brief with findings and implications
├── renv.lock                  # Locked package versions for reproducibility
└── README.md
```

## Reproducing the Analysis

1. Clone this repository and open `NHTS_EV_Analysis.Rproj` in RStudio (this restores the correct working directory).
2. Run `renv::restore()` to install the exact package versions used in this analysis.
3. Run the test suite to confirm the core functions work as expected:
   ```r
   testthat::test_dir("tests/testthat/")
   ```
4. Render the full analysis:
   ```r
   quarto::quarto_render("analysis.qmd")
   ```

## Data Source

NHTS data is publicly available from the National Household Travel Survey. Raw files are included in `data-raw/` for reproducibility.

## Author

Kenneth Murira
