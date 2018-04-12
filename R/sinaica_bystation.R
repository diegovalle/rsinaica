#' Get data from a measuring station that reports to SINAICA
#'
#'
#'
#' @param station_id the numeric code correspongind to each station. See
#' \code{\link{stations_sinaica}} for a list of stations and their ids.
#' @param parameter type of parameter to download
#' \itemize{
#'  \item{"BEN"}{ - Benceno}
#'  \item{"CH4"}{ - Metano}
#'  \item{"CN"}{ - Carbono negro}
#'  \item{"CO"}{ - Monóxido de carbono}
#'  \item{"CO2"}{ - Dióxido de carbono}
#'  \item{"DV"}{ - Dirección del viento}
#'  \item{"H2S"}{ - Acido Sulfhídrico}
#'  \item{"HCNM"}{ - Hidrocarburos no metánicos}
#'  \item{"HCT"}{ - Hidrocarburos Totales}
#'  \item{"HR"}{ - Humedad relativa}
#'  \item{"HRI"}{ - Humedad relativa interior}
#'  \item{"IUV"}{ - Índice de radiación ultravioleta}
#'  \item{"NO"}{ - Óxido nítrico}
#'  \item{"NO2"}{ - Dióxido de nitrógeno}
#'  \item{"NOx"}{ - Óxidos de nitrógeno}
#'  \item{"O3"}{ - Ozono}
#'  \item{"PB"}{ - Presión Barométrica}
#'  \item{"PM10"}{ - Partículas menores a 10 micras}
#'  \item{"PM2.5"}{ - Partículas menores a 2.5 micras}
#'  \item{"PP"}{ - Precipitación pluvial}
#'  \item{"PST"}{ - Particulas Suspendidas totales}
#'  \item{"RS"}{ - Radiación solar}
#'  \item{"SO2"}{ - Dióxido de azufre}
#'  \item{"TMP"}{ - Temperatura}
#'  \item{"TMPI"}{ - Temperatura interior}
#'  \item{"UVA"}{ - Radiación ultravioleta A}
#'  \item{"VV"}{ - Radiación ultravioleta B}
#'  \item{"XIL"}{ - Xileno}
#' }
#' @param type The type of data to download. One of the following:
#' \itemize{
#'  \item{"Crude"}{ - Crude data that has not been validated}
#'  \item{"Validated"}{ - Validated data (may not be the most up-to-date)}
#'  \item{"Manual"}{ - Manually collected data that is sent to an external for lab analysis (may no be collected daily)}
#' }
#' @param start_date start of range in YYYY-MM-DD format
#' @param end_date end of range from which to download data in YYYY-MM-DD format
#'
#' @return data.frame with air quality data
#' @importFrom dplyr filter
#' @importFrom httr POST http_error http_type content status_code add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_replace_all str_extract
#' @importFrom utils data
#' @importFrom stats runif
#' @export
#' @examples
#' stations_sinaica[which(stations_sinaica$station_name == "Xalostoc"), 1:5]
#' df <- sinaica_bystation(271, "O3", "2015-09-11", "2015-09-11", "Crude")
#' head(df)
#'
sinaica_bystation <- function(station_id,
                            parameter,
                            start_date,
                            end_date,
                            type = "Crude"
                            ) {
  if (missing(station_id))
    stop(paste0("argument station_id is missing, please provide it. The",
                " data.frame",
                " `stations_sinaica` contains a list of all station ids",
                " and names"), call. = FALSE)
  if (!is.integer2(station_id))
    stop(paste0("argument station_id must be an integer The",
                " data.frame",
                " `stations_sinaica` contains a list of all station ids",
                " and names"), call. = FALSE)

  if (missing(start_date))
    stop("You need to specify a date YYYY-MM-DD", call. = FALSE)
  if (length(start_date) != 1)
    stop("start_date should be a date in YYYY-MM-DD format", call. = FALSE)
  if (!is.Date(start_date))
    stop("start_date should be in YYYY-MM-DD format", call. = FALSE)

  if (missing(end_date))
    stop("You need to specify a date YYYY-MM-DD", call. = FALSE)
  if (length(end_date) != 1)
    stop("end_date should be a date in YYYY-MM-DD format", call. = FALSE)
  if (!is.Date(end_date))
    stop("end_date should be in YYYY-MM-DD format", call. = FALSE)

  check_arguments(parameter,
                  valid = c("BEN", "CH4", "CN", "CO", "CO2", "DV",
                           "H2S", "HCNM", "HCT",
                           "HR", "HRI", "IUV", "NO", "NO2",
                           "NOx",
                           "O3", "PB", "PM10",
                           "PM2.5", "PP", "PST", "RS", "SO2",
                           "TMP", "TMPI", "UVA", "UVB",
                           "VV", "XIL"),
                  "parameter")
  check_arguments(type,
                  valid = c("Crude", "Validated", "Manual"),
                  "type")


  if (as.Date(end_date) > .increase_month(start_date))
    stop("The maximum amount of data you can download is 1 month",
         call. = FALSE)

  if (start_date > end_date)
    stop("start_date should be less than or equal to end_date")
  if ( type == "Manual" & end_date == start_date)
    stop(paste0("for type 'Manual' data you can only request",
                " a range longer than a day"),
         call. = FALSE)
  type <- switch(type,
                 "Crude"     = "",
                 "Validated" = "V",
                 "Manual"    = "M"
  )

  url <- "http://sinaica.inecc.gob.mx/pags/datGrafs.php"
  fd <- list(
    estacionId  = station_id,
    param       = parameter,
    fechaIni    = start_date,
    rango       = ndays_to_range(start_date, end_date),
    tipoDatos   = type
  )
  result <- POST(url,
                 add_headers("user-agent" =
                               "https://github.com/diegovalle/rsinaica"),
                 body = fd,
                 encode = "form")
  if (http_error(result))
    stop(sprintf("The request to <%s> failed [%s]",
                 url,
                 status_code(result)
    ), call. = FALSE)
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
                      unit =  character(),
                      value = numeric(),
                      stringsAsFactors = FALSE)
           )
  df$bandO <- NULL
  names(df) <- c("id", "date", "hour", "value", "valid")
  df$value <- as.numeric(df$value)
  df$unit <- .recode_sinaica_units(parameter)
  df$station_id <- as.integer(station_id)
  df$hour <- as.integer(df$hour)
  df$valid <- as.integer(df$valid)

  lim_perm <- switch(parameter, PM10 = 600, PM2.5 = 175, NO2 = .21,
                     SO2 = .2, CO = 15,
                     O3 = .2, 10000000000)
  df$value[which(df$value > lim_perm)] <- NA_real_
  df$value[which(df$value < 0)] <- NA_real_

  data("stations_sinaica", package = "rsinaica", envir = environment())
  df <- left_join(df, stations_sinaica[, c("station_id", "station_name")],
                  by = "station_id")
  df <- filter(df, date <= end_date)
  ## As not to overload the server wait a random value before the next call
  Sys.sleep(runif(1, max = .5))
  df[, c("station_id",  "station_name", "date", "hour",
         "valid", "unit", "value")]
}
