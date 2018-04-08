context("test-sinaica_bystation.R")

# Visit http://sinaica.inecc.gob.mx/data.php to manually check the values
test_that("sinaica_bystation returns correct data", {
  skip_on_cran()

  # Test errors in parameters
  expect_error(sinaica_bystation(271, "PM10", "2015-09-11", "1 day", "Manual"),
                "for type 'Manual' data you can only request")
  expect_error(sinaica_bystation(271, "ERROR", "2015-09-11", "1 week",
                                 "Manual"),
                "parameter should be one of: BEN, CH4")
  expect_error(sinaica_bystation(271, "PM10", "2015-09-11", "2 weeks", "ERROR"),
                "type should be one of: Crude, Validated, Manual")
  expect_error(sinaica_bystation(271, "PM10", "ERROR", "1 week", "Manual"),
                "date should be in YYYY-MM-DD format")
  expect_error(sinaica_bystation(271, "PM10", "2015-09-11", "ERROR", "Manual"),
                "range should be one of: 1 day, 1 week, 2 weeks, 1 month")
  expect_error(sinaica_bystation(),
               "argument station_id is missing")
  expect_error(sinaica_bystation(271, start_date = "2000-01-01"),
               "argument parameter should not be missing")


  # Datos Crudos
  df <- sinaica_bystation(271, "O3", "2015-09-11", "1 day", "Crude")
  expect_equal(df$value, c(0.013, 0.015, 0.006, 0.014,
                          0.01, 0.003, 0.002, 0.004, 0.014,
                          0.026, 0.038, 0.05, 0.063, 0.045,
                          0.027, 0.027, 0.029, 0.024,
                          0.016, 0.007, 0.01, 0.01, 0.01, 0.008))

  # Datos validados
  df <- sinaica_bystation(271, "O3", "2015-10-14", "1 day", "Validated")
  expect_equal(df$value, c(0.022, 0.024, 0.023, 0.021, 0.014,
                           0.004, 0.002, 0.003, 0.012,
                           0.023, 0.029, 0.028, 0.034, 0.028,
                           0.026, 0.024, 0.024, 0.019,
                           0.015, 0.016, 0.014, 0.016, 0.017, 0.016))

  # Datos manuales
  df <- sinaica_bystation(271, "PM10", "2015-12-26", "1 week", "Manual")
  expect_equal(df$value, 75)

  df <- sinaica_bystation(31, "PM10", "2017-06-26", "1 day", "Crude")
  expect_equal(unname(unlist(lapply(df, typeof))),
         c("integer", "character", "character", "integer", "integer",
           "character", "double"))
})
