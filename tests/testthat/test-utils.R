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

test_that("is.integer2 works", {
  expect_true(is.integer2(1986))
  expect_true(is.integer2(1986.0))
  expect_false(is.integer2(99.2))
  expect_false(is.integer2(99.0000000001))
  expect_false(is.integer2(character(0)))
  expect_false(is.integer2(NULL))
  expect_false(is.integer2(1.0000000000001))
  expect_true(is.integer2(2018))
  expect_true(is.integer2(c(1999:2010)[3]))
  expect_true(is.integer2(as.numeric(11)))
  expect_true(is.integer2(as.double(11)))
  expect_true(is.integer2(as.integer(22)))
  expect_true(is.integer2(as.single(12)))
  expect_false(is.integer2(NA))
  # Not an integer
  expect_false(is.integer2(NA_real_))
})

test_that(".increase_month", {
  expect_equal(.increase_month("2000-12-01"), as.Date("2001-01-01"))
  expect_equal(.increase_month("1999-12-01"), as.Date("2000-01-01"))
  expect_equal(.increase_month("1999-09-01"), as.Date("1999-10-01"))
  expect_equal(.increase_month("2011-02-28"), as.Date("2011-03-28"))
  expect_equal(.increase_month("2011-01-31"), as.Date("2011-02-28"))
})

test_that("ndays_to_range", {
  ## 1 = 1 day, 2 = 1 week, 3 = 2 weeks, 4 = 1 month
  ## 5 = 1 año, 6 = 2 años
  expect_equal(ndays_to_range("2005-01-01", "2005-01-01"), 1)
  # Tue to Mon
  expect_equal(ndays_to_range("2018-04-03", "2018-04-09"), 2)
  expect_equal(ndays_to_range("2018-04-03", "2018-04-10"), 3)
  expect_equal(ndays_to_range("2005-01-01", "2005-02-10"), 5)
  expect_equal(ndays_to_range("2018-03-03", "2018-03-16"), 3)
  expect_equal(ndays_to_range("2018-03-03", "2018-03-17"), 4)
  expect_equal(ndays_to_range("2026-03-03", "2027-03-17"), 6)
  expect_equal(ndays_to_range("2025-02-28", "2026-02-28"), 6)
  expect_equal(ndays_to_range("2025-02-28", "2025-03-28"), 5)
  expect_equal(ndays_to_range("2025-02-28", "2025-03-27"), 4)
})

test_that("missing arguments", {
  expect_error(check_arguments(arg_val = null))
})

test_that("increase dates", {
  expect_equal(.increase_year("2025-01-01", 2), as.Date("2027-01-01"))
  expect_equal(.increase_month("2025-01-01"), as.Date("2025-02-01"))
})
