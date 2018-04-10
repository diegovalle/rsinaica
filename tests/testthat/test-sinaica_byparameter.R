context("test-sinaica_byparameter.R")

test_that("sinaica_byparameter works", {
  skip_on_cran()

  # Errors
  expect_error(sinaica_byparameter("ERROR", "2017-01-01", "2017-01-31"),
               "parameter should be one of: BEN, CH4")
  expect_error(sinaica_byparameter("PM2.5", "2017-01-32", "2017-01-31"),
               "start_date should be in YYYY-MM-DD")
  expect_error(sinaica_byparameter("PM2.5", "2017-02-01", "2017-02-29"),
               "end_date should be in YYYY-MM-DD")
  expect_error(sinaica_byparameter("O3", "2017-01-01", "2016-12-31"),
               "start_date should be less than or equal")
  # attempting to download more than 1 month of data should throw an error
  expect_error(sinaica_byparameter("PM2.5", "2017-01-01", "2017-02-31"))

  df <- sinaica_byparameter("O3", "2015-10-14", "2015-10-14")
  expect_equal(df$value[1:10], c(0.0066721, 0.014782, 0.011957,
                                 0.0021908, 0.0027581, 0.0063391,
                                 0.0089907, 0.0051245, 0.0018884, 0.0029096))

  df <- sinaica_byparameter("O3", "2015-10-14", "2015-10-14", autoclean = FALSE)
  expect_equal(df$valorAct[1:10], c("0.0066721", "0.014782", "0.011957",
                                    "0.0021908", "0.0027581", "0.0063391",
                                    "0.0089907", "0.0051245", "0.0018884",
                                    "0.0029096"))
  expect_equal(names(df), c("id", "estacionesId", "fecha", "hora",
                            "parametro", "valorOrig",
               "banderasOrig", "validoOrig", "valorAct",
               "validoAct", "fechaValidoAct",
               "nivelValidacion"))

  df <- sinaica_byparameter("CN", "1997-01-01", "1997-01-01")
  expect_equal(unname(unlist(lapply(df, typeof))),
               c("character", "integer", "character", "character", "character",
                 "character", "integer", "character", "integer", "character",
                 "character", "character", "character",
                 "character", "character",
                 "character", "character", "character", "double"))

  df <- sinaica_byparameter("PM10", "2014-01-01", "2014-01-05",
                      "Manual")
  expect_equal(df$value[1:10], c(81, 54, 29, 58, 29, 32, 86, 15, 21, 55))

  df <- sinaica_byparameter("PM10", "2014-01-01", "2014-01-05",
                            "Manual", autoclean = FALSE)
  expect_equal(unname(unlist(lapply(df, typeof))),
               c("character", "integer", "character", "character", "character",
                 "character", "character", "character", "character"))

  ## should be an empty data.frame
  df <- sinaica_byparameter("PM10", "2014-01-01", "2014-01-01",
                            "Manual", autoclean = FALSE)
  expect_equal(unname(unlist(lapply(df, typeof))),
               c("character", "integer", "character", "character", "character",
                 "character", "character", "character", "character"))
})
