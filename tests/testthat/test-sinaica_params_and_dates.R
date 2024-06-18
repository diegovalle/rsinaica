context("test-sinaica_params_and_dates.R")

test_that("sinaica_station_dates", {
  skip_on_cran()

  expect_error(sinaica_station_dates(),
               "argument station_id is missing, please provide it")
  expect_error(sinaica_station_dates("ERROR"),
               "argument station_id must be an integer")

  expect_equal(sinaica_station_dates(271, "Manual"),
               c("1997-01-02", "2022-12-31"))
  expect_equal(sinaica_station_dates(42, "Manual"), c(NA, NA))
})
