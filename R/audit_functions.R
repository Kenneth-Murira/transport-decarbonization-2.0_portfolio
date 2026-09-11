library(dplyr)
library(broom)

run_categorical_audit <- function(data, predictor_col, target_col) {
  # Create the contingency table
  tbl <- table(
    data[[predictor_col]],
    data[[target_col]]
  )

  # Execute Chi-Square Pearson's test
  test_res <- chisq.test(tbl)

  # Calculate Cramer's V
  n <- sum(tbl)
  min_dim <- min(
    nrow(tbl) - 1,
    ncol(tbl) - 1
  )

  cramers_v <- sqrt(
    test_res$statistic / (n * min_dim)
  )

  # Tidy the statistical summary
  tidy_summary <- tidy(test_res) %>%
    mutate(
      predictor = predictor_col,
      cramers_v = as.numeric(cramers_v)
    ) %>%
    select(
      predictor,
      statistic,
      p.value,
      parameter,
      cramers_v
    )
  # Return summary and residuals
  return(
    list(
      summary = tidy_summary,
      residuals = test_res$stdres
    )
  )
}






