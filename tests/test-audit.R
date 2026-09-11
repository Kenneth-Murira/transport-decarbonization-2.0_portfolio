# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)

source("../../R/audit_functions.R")

test_that("run_categorical_audit returns expected list structure", {

  # Generate reproducible dummy data
  set.seed(123)

  mock_df <- data.frame(
    category = rep(c("A", "B"), each = 50),
    target = sample(c("Yes", "No"), 100, replace = TRUE)
  )

  # Run the audit function
  res <- run_categorical_audit(
    mock_df,
    "category",
    "target"
  )

  # Check output structure
  expect_type(res, "list")

  expect_named(
    res,
    c("summary", "residuals")
  )

  # Check that Cramér's V was calculated
  expect_true(
    "cramers_v" %in% colnames(res$summary)
  )

  # Check that Cramér's V is numeric
  expect_true(
    is.numeric(res$summary$cramers_v)
  )

  # Check that residuals are numeric
  expect_true(
    is.matrix(res$residuals)
  )
})
