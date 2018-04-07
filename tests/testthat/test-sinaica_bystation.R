context("test-sinaica.R")

# Visit http://sinaica.inecc.gob.mx/data.php to manually check the values
test_that("sinaica_station returns correct data", {
  skip_on_cran()

  # Test errors in parameters
  expect_error(sinaica_bystation(271, "PM10", "2015-09-11", "Manual", "1 day"),
                "for type 'M' data you can only request")
  expect_error(sinaica_bystation(271, "ERROR", "2015-09-11", "Manual", "1 week"),
                "parameter should be one of: BEN, CH4")
  expect_error(sinaica_bystation(271, "PM10", "2015-09-11", "ERROR", "2 weeks"),
                "type should be one of: Crude, Validated, Manual")
  expect_error(sinaica_bystation(271, "PM10", "ERROR", "Manual", "1 week"),
                "date should be in YYYY-MM-DD format")
  expect_error(sinaica_bystation(271, "PM10", "2015-09-11", "Manual", "ERROR"),
                "range should be one of: 1 day, 1 week, 2 weeks, 1 month")



  # Datos Crudos
  df <- sinaica_bystation(271, "O3", "2015-09-11", "Crude", "1 day")
  expect_equal(df$value,c(0.013, 0.015, 0.006, 0.014,
                          0.01, 0.003, 0.002, 0.004, 0.014,
                          0.026, 0.038, 0.05, 0.063, 0.045,
                          0.027, 0.027, 0.029, 0.024,
                          0.016, 0.007, 0.01, 0.01, 0.01, 0.008))

  # Datos validados
  df <- sinaica_bystation(271, "O3", "2015-10-14", "Validated", "1 day")
  expect_equal(df$value, c(0.022, 0.024, 0.023, 0.021, 0.014,
                           0.004, 0.002, 0.003, 0.012,
                           0.023, 0.029, 0.028, 0.034, 0.028,
                           0.026, 0.024, 0.024, 0.019,
                           0.015, 0.016, 0.014, 0.016, 0.017, 0.016))

  # Datos manuales
  df <- sinaica_bystation(271, "PM10", "2015-12-26", "Manual", "1 week")
  expect_equal(df$value, 75)
})
