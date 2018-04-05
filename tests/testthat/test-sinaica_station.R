context("test-sinaica.R")

# Visit http://sinaica.inecc.gob.mx/data.php to manually check the values
test_that("sinaica_station returns correct data", {
  skip_on_cran()

  # Test errors in parameters
  expect_error( sinaica_station(271, "PM10", "M", "2015-09-11", "1"),
                "for type 'M' data you can only request")
  expect_error( sinaica_station(271, "ERROR", "M", "2015-09-11", "2"),
                "'arg' should be one of")
  expect_error( sinaica_station(271, "PM10", "ERROR", "2015-09-11", "2"),
                "'arg' should be one of")
  expect_error( sinaica_station(271, "PM10", "M", "ERROR", "2"),
                "date should be in YYYY-MM-DD format")
  expect_error( sinaica_station(271, "PM10", "M", "2015-09-11", "ERROR"),
                "'arg' should be one of")



  # Datos Crudos
  df <- sinaica_station(271, "O3", "C", "2015-09-11", "1")
  expect_equal(df$value,c(0.013, 0.015, 0.006, 0.014,
                          0.01, 0.003, 0.002, 0.004, 0.014,
                          0.026, 0.038, 0.05, 0.063, 0.045,
                          0.027, 0.027, 0.029, 0.024,
                          0.016, 0.007, 0.01, 0.01, 0.01, 0.008))

  # Datos validados
  df <- sinaica_station(271, "O3", "V", "2015-10-14", "1")
  expect_equal(df$value, c(0.022, 0.024, 0.023, 0.021, 0.014,
                           0.004, 0.002, 0.003, 0.012,
                           0.023, 0.029, 0.028, 0.034, 0.028,
                           0.026, 0.024, 0.024, 0.019,
                           0.015, 0.016, 0.014, 0.016, 0.017, 0.016))

  # Datos manuales
  df <- sinaica_station(271, "PM10", "M", "2015-12-26", "2")
  expect_equal(df$value, 75)
})
