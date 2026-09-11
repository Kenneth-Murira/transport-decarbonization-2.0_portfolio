# Load Packages
library(dplyr)
library(broom)
library(purrr)
library(readr)

# Load cleaned analytical dataset
df_analysis <- read_rds("data/nhts_analysis.rds")

# Check the dataset
glimpse(df_analysis)
count(df_analysis, Has_EV)

# Load the custom statistical function
source("R/audit_functions.R")

# Create audit Dataset and run the tests
df_audit <- df_analysis %>%
  filter(Has_EV %in% c("Yes", "No"))

#Define categorical predictors
predictors <- c(
  "Income_Bracket",
  "Region",
  "HH_Size"
)

# Run the statistical audit and name each result
audit_results <- predictors %>%
  set_names() %>%
  map(
    ~ run_categorical_audit(
      data = df_audit,
      predictor_col = .x,
      target_col = "Has_EV"
    )
  )

# Combine the results
audit_summary <- map_dfr(
  audit_results,
  "summary"
)

# Display final results
audit_summary



