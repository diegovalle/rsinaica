context("test-sinaica_parameter.R")

test_that("sinaica_parameter works", {
  skip_on_cran()

  # Errors
  expect_error(sinaica_parameter("ERROR", "2017-01-01", "2017-01-31"),
               "'arg' should be one of")
  expect_error(sinaica_parameter("PM2.5", "2017-01-32", "2017-01-31"),
               "start_date should be in YYYY-MM-DD")
  expect_error(sinaica_parameter("PM2.5", "2017-02-01", "2017-02-29"),
               "end_date should be in YYYY-MM-DD")
  expect_error(sinaica_parameter("O3", "2017-01-01", "2016-12-31"),
               "start_date should be less than or equal")
  # attempting to download more than 1 month of data should throw an error
  expect_error(sinaica_parameter("PM2.5", "2017-01-01", "2017-02-31"))

  df <- sinaica_parameter("O3", "2015-10-14", "2015-10-14")
  expect_equal(df$value[1:10], c(0.0066721, 0.014782, 0.011957,
                                 0.0021908, 0.0027581, 0.0063391,
                                 0.0089907, 0.0051245, 0.0018884, 0.0029096))
})
