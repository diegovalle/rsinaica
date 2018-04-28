context("test-get-parameters_and_dates.R")

test_that("get-parameters_and_dates", {
  skip_on_cran()

  expect_error(sinaica_station_param("112"),
               "argument station_id must be an integer")
  expect_error(sinaica_station_param(33.4),
               "argument station_id must be an integer")
  expect_error(sinaica_station_param(),
               "argument station_id is missing")

  df <- sinaica_station_param(271, "Crude")
  expect_equal(df$parameter_code, c("SO2", "NO2", "DV", "HR", "CO",
                                  "NO", "NOx", "O3", "PM10",
                                  "PM2.5", "PB", "TMP", "VV"))
  df <- sinaica_station_param(271, "Manual")
  expect_equal(df$parameter_code, c("PM10", "PM2.5"))
  df <- sinaica_station_param(33, "Validated")
  expect_equal(df$parameter_code, c("SO2", "NO2", "DV", "HR", "CO",
                                  "NO", "NOx", "O3", "PM10",
                                  "PM2.5", "PP", "PB", "RS", "TMPI", "VV"))
})

test_that("sinaica_station_dates", {
  skip_on_cran()
  expect_equal(sinaica_station_dates(271, "Manual"), c("1997-01-02", "2015-12-26"))
  expect_equal(sinaica_station_dates(42, "Manual"), c(NA, NA))
})
