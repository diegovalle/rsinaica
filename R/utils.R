# test if a date is in YYYY-MM-DD format
is.Date <- function(date, date.format = "%Y-%m-%d") {
  if (length(date) < 1)
    return(FALSE)
  tryCatch(!is.na(as.Date(date, date.format)),
           error = function(e) {
             FALSE
           })
}

# test if int is an integer
is.integer2 <- function(int) {
  if (length(int) < 1)
    return(FALSE)
  if (any(is.na(int)))
    return(FALSE)
  tryCatch(identical(int, as.integer(floor(int))) |
             identical(int, as.double(floor(int))) |
             identical(int, as.single(floor(int))),
           error = function(e) {
             FALSE
           })
}

check_arguments <- function(arg_val, valid, arg_name) {
  if (missing(arg_val))
    stop(sprintf("argument %s should not be missing", arg_name), call. = FALSE)
  val <- any(
    unlist(
      lapply(valid, function(x) identical(arg_val, x))
    )
  )
  if (!val)
    stop(sprintf("%s should be one of: %s",
                 arg_name,
                 paste(valid, collapse = ", ")), call. = FALSE)
}


#' recode units from SINAICA
#'
#' @param pollutant
#'
#' @return vector
#' @importFrom dplyr recode
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
         "DV" = "\u00b0A")
}
