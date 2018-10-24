# test if a date is in YYYY-MM-DD format
is.Date <- function(date, date.format = "%Y-%m-%d") {
  if (length(date) < 1) {
    return(FALSE)
  }
  tryCatch(!is.na(as.Date(date, date.format)),
    error = function(e) {
      FALSE
    }
  )
}

# test if int is an integer
is.integer2 <- function(int) {
  if (length(int) < 1) {
    return(FALSE)
  }
  if (any(is.na(int))) {
    return(FALSE)
  }
  tryCatch(identical(int, as.integer(floor(int))) |
    identical(int, as.double(floor(int))) |
    identical(int, as.single(floor(int))),
  error = function(e) {
    FALSE
  }
  )
}

check_arguments <- function(arg_val, valid, arg_name) {
  if (missing(arg_val)) {
    stop(sprintf("argument %s should not be missing", arg_name), call. = FALSE)
  }
  val <- any(
    unlist(
      lapply(valid, function(x) identical(arg_val, x))
    )
  )
  if (!val) {
    stop(sprintf(
      "%s should be one of: %s",
      arg_name,
      paste(valid, collapse = ", ")
    ), call. = FALSE)
  }
}

#' Increase a date by 1 month
#'
#' @param d a date
#'
#' @return month + 1
#' @importFrom lubridate period %m+%
#' @keywords internal
.increase_month <- function(d) {
  as.Date(d) %m+% period("m")
}

# Convert a date range to daily, weekly or monthly ranges
# The SINAICA website instead of accepting a date range
# accepts a numerica value specifying the date range
## 1 = 1 day, 2 = 1 week, 3 = 2 weeks, 4 = 1 month
ndays_to_range <- function(start_date, end_date) {
  num_days <- as.numeric(as.Date(end_date) - as.Date(start_date) + 1)
  ## 1 = 1 day, 2 = 1 week, 3 = 2 weeks, 4 = 1 month
  ranges <- c(1, 2, 3, 4)
  ## day number to assign to each range value
  cuts <- c(1, 2, 8, 15)
  ranges[findInterval(num_days, cuts)]
}

#' recode units from SINAICA
#'
#' @param pollutant type of pollutant to recode
#'
#' @return vector
#' @importFrom dplyr recode
#' @keywords internal
.recode_sinaica_units <- function(pollutant) {
  recode(pollutant,
    "O3" = "ppm",
    "CO" = "ppm",
    "CO2" = "ppm",
    "NO2" = "ppm",
    "NO" = "ppm",
    "NOx" = "ppm",
    "NOX" = "ppm",
    "SO2" = "ppm",
    "H2S" = "ppm",
    "CH4" = "ppm",
    "HCNM" = "ppm",
    "HCT" = "ppm",
    "XIL" = "ppm",
    "EB" = "ppm",
    "CN" = "ppm",
    "PM10" = "\u00b5g/m\u00b3",
    "PM2.5" = "\u00b5g/m\u00b3",
    "BEN" = "ppb",
    "TMP" = "\u00b0C",
    "TMPI" = "\u00b0C",
    "PB" = "mmHg",
    "O3Pm" = "mmHg",
    "SO2Pm" = "mmHg",
    "COPm" = "mmHg",
    "NOxPm" = "mmHg",
    "PP" = "mm",
    "VV" = "m/s",
    "RS" = "W/m\u00b2",
    "UVA" = "mW/m\u00b2",
    "UVB" = "Med/h",
    "HR" = "%",
    "HRI" = "%",
    "DV" = "\u00b0A"
  )
}
