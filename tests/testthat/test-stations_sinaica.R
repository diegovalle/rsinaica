context("test-stations_sinaica.R")

# No duplicate stations in data.frame
test_that("sinaica_station_data returns correct data", {
  expect_false(any(duplicated(stations_sinaica$station_id)))
})
