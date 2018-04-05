context("test-parameters_and_dates.R")

test_that("multiplication works", {
  skip_on_cran()
  df <- get_station_parameters(271, "C")
  expect_equal(df$parameter_id, c("SO2", "NO2", "DV", "HR", "CO",
                                  "NO", "NOx", "O3", "PM10",
                                  "PM2.5", "PB", "TMP", "VV"))
  df <- get_station_parameters(271, "M")
  expect_equal(df$parameter_id, c("PM10", "PM2.5"))
  df <- get_station_parameters(33, "V")
  expect_equal(df$parameter_id, c("SO2", "NO2", "DV", "HR", "CO",
                                  "NO", "NOx", "O3", "PM10",
                                  "PM2.5", "PP", "PB", "RS", "TMPI", "VV"))
})

test_that("multiplication works", {
  skip_on_cran()
  expect_equal(get_station_dates(271, "M"), c("1997-01-02", "2015-12-26"))
})

