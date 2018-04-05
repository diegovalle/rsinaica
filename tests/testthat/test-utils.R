context("test-utils.R")

test_that("is.Date works", {
  expect_false(is.Date("test"))
  expect_true(is.Date("2018-01-21"))
  expect_true(is.Date("2005-01-01"))
  expect_true(is.Date("2009-01-01"))
  expect_false(is.Date("2009-13-01"))
  expect_false(is.Date("20011-13-01"))
  expect_false(is.Date("2009-11-34"))
  expect_false(is.Date("2009-02-30"))
  expect_false(is.Date(character(0)))
  expect_false(is.Date(NULL))
  expect_false(is.Date(NA))
})


