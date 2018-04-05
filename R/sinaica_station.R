

#' Title
#'
#' @param type test
#'
#' @return data.frame
#' @importFrom httr POST http_error content
#' @importFrom jsonlite fromJSON
#' @export
#'
.get_stations_sinaica <- function(type) {
  url = "http://sinaica.inecc.gob.mx/lib/j/php/getData.php"
  fd <- list(
    tabla  = "Datos",
    fields = "",
    where  = "estacionesId=271 and fecha = '2015-01-01' limit 24"
  )

  result <- POST(url,
                 body = fd,
                 encode = "form")
  html_text <- content(result, "text", encoding = "UTF-8")
  df2 <- fromJSON(html_text)

}


#' Get data from a SINAICA reporting station
#'
#' @param station_id See stations_sinaica
#' @param parameter type of parameter to download
#' @param type The type of data to download. One of the following:
#' \itemize{
#'  \item{"C"}{ - Crude data that has not been validated}
#'  \item{"V"}{ - Validated data}
#'  \item{"M"}{ - Manual data}
#' }
#' @param date day to download or start of range
#' @param range how much data to download
#' \itemize{
#'  \item{"1"}{ - 1 day}
#'  \item{"2"}{ - 1 week}
#'  \item{"3"}{ - 2 weeks}
#'  \item{"4"}{ - 1 month}
#' }
#'
#' @return data.frame with air quality data
#' @importFrom httr POST http_error http_type content status_code
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_replace_all str_extract
#' @importFrom utils data
#' @export
#' @examples
#' stations_sinaica[which(stations_sinaica$station_name == "Xalostoc"), 1:5]
#' df <- sinaica_station(271, "O3", "C", "2015-09-11", "1")
#' head(df)
#'
sinaica_station <- function(station_id,
                            parameter = c("BEN", "CH4", "CN", "CO", "CO2", "DV",
                                          "H2S", "HCNM", "HCT",
                                          "HR", "HRI", "IUV", "NO", "NO2",
                                          "NOx",
                                          "O3", "PB", "PM10",
                                          "PM2.5", "PM25", "PP", "PST", "RS", "SO2",
                                          "TMP", "TMPI", "UVA", "UVB",
                                          "VV", "XIL"),
                            type = c("C", "V", "M"),
                            date,
                            range = c("1", "2", "3", "4")) {
  if (!is.Date(date))
    stop("date should be in YYYY-MM-DD format", call. = FALSE)
  type <- match.arg(type)
  parameter <- match.arg(parameter)
  range <- match.arg(range)
  if ((type == "M") & range == "1")
    stop("for type 'M' data you can only request a range longer than a day",
         call. = FALSE)
  if (type == "C")
    type <- ""
  url <- "http://sinaica.inecc.gob.mx/pags/datGrafs.php"
  fd <- list(
    estacionId  = station_id,
    param   = parameter,
    fechaIni    = date,
    rango       = range, # 1 = day, 2 = 1 week, 3 = 2 weeks, 4 = 1 month
    tipoDatos   = type
  )
  result <- POST(url,
                 body = fd,
                 encode = "form")
  if (http_error(result))
    stop("The request to <%s> failed [%s]",
         url,
         status_code(result), call. = FALSE)
  if (http_type(result) != "text/html")
    stop(paste0(url, " did not return text/html", call. = FALSE))
  json_text <- content(result, "text", encoding = "UTF-8")
  df <- fromJSON(str_replace_all(str_extract(json_text,
                                             "var dat = \\[(.|\n)*?\\];"),
                                 "var dat = |;",
                                 ""))
  if (!length(df))
    return(data.frame(station_id =  integer(),
                      station_name =  character(),
                      date =  character(),
                      hour = integer(),
                      valid = integer(),
                      units =  character(),
                      value = character(),
                      stringsAsFactors=FALSE)
           )
  df$bandO <- NULL
  names(df) <- c("id", "date", "hour", "value", "valid")
  df$value <- as.numeric(df$value)
  df$units <- .recode_sinaica_units(parameter)
  df$station_id <- as.integer(station_id)
  df$hour <- as.integer(df$hour)
  df$valid <- as.integer(df$valid)

  data("stations_sinaica", package="rsinaica", envir=environment())
  df <- left_join(df, stations_sinaica[, c("station_id", "station_name")],
                  by = "station_id")

  df[, c("station_id",  "station_name", "date", "hour",
         "valid", "units", "value")]
}

