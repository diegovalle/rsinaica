
#' Get data for all stations by parameter
#'
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
#' @param start_date start date
#' @param end_date end date
#' @param autoclean wether to automatically remove invalid date and make sure
#' extreme values are turned to NAs
#'
#' @return data.frame with air quality data
#' @importFrom httr POST http_error content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr left_join
#' @importFrom lubridate day<- days_in_month
#' @importFrom utils data
#' @export
#' @examples
#' \dontrun{
#' ## May take several seconds
#' df <- sinaica_byparameter("O3", "2015-10-14", "2015-10-14")
#' head(df)
#' }
sinaica_byparameter <- function(parameter,
                              start_date,
                              end_date,
                              autoclean = TRUE) {
  if (missing(start_date))
    stop("You need to specify a start date YYYY-MM-DD", call. = FALSE)
  if (missing(end_date))
    stop("You need to specify an end date YYYY-MM-DD", call. = FALSE)
  if (!is.Date(start_date))
    stop("start_date should be in YYYY-MM-DD format", call. = FALSE)
  if (!is.Date(end_date))
    stop("end_date should be in YYYY-MM-DD format", call. = FALSE)
  check_arguments(parameter,
                  valid = c("BEN", "CH4", "CN", "CO", "CO2", "DV",
                            "H2S", "HCNM", "HCT",
                            "HR", "HRI", "IUV", "NO", "NO2",
                            "NOx",
                            "O3", "PB", "PM10",
                            "PM2.5", "PM25", "PP", "PST", "RS", "SO2",
                            "TMP", "TMPI", "UVA", "UVB",
                            "VV", "XIL"),
                  "parameter")
  if (start_date > end_date)
    stop("start_date should be less than or equal to end_date")

  d <- as.Date(start_date)
  day(d) <- days_in_month(d)
  if (as.Date(end_date) > d)
    stop("The maximum amount of data you can download is 1 month",
         call. = FALSE)

  url <-  "http://sinaica.inecc.gob.mx/lib/j/php/getData.php"
  fd <- list(
    tabla  = "Datos",
    fields = "",
    where  = paste0("parametro = '", parameter, "' and fecha >= '", start_date,
                    "' and fecha <= '", end_date, "'")
  )

  result <- POST(url,
                 body = fd,
                 encode = "form")
  if (http_error(result))
    stop(sprintf("The request to <%s> failed [%s]",
                 url,
                 status_code(result)
    ), call. = FALSE)
  if (http_type(result) != "text/html")
    stop(paste0(url, " did not return text/html", call. = FALSE))
  html_text <- content(result, "text", encoding = "UTF-8")
  df <- fromJSON(html_text)
  df$estacionesId <- as.integer(df$estacionesId)

  if (identical(autoclean, TRUE)) {
    ## Values above this are suppossed to be invalid
    lim_perm <- switch(parameter, PM10 = 600, PM2.5 = 175, NO2 = .21,
                      SO2 = .2, CO = 15,
                      O3 = .2, 10000000000)

    df$value <- df$valorAct
    df$value <- as.numeric(df$value)
    df$value[which(!is.finite(df$value))] <- NA
    df$value[which(df$validoAct == 0)] <- NA
    df$value[which(df$value < 0)] <- NA
    df$value[which(df$value > lim_perm)] <- NA

    names(df) <- c("id", "station_id", "date", "hour",
                   "parameter", "value_original",
                   "flag_original", "valid_original", "value_actual",
                   "valid_actual", "date_validated",
                   "validation_level", "value")
    df <- left_join(df, stations_sinaica[, c("station_id",
                                             "network_name",
                                             "network_code",
                                             "network_id")],
                     by = c("station_id" = "station_id"))
    df$units <- .recode_sinaica_units(parameter)
    df <- df[, c("id", "station_id", "network_name",
           "network_code",
           "network_id", "date", "hour",
           "parameter", "value_original",
           "flag_original", "valid_original", "value_actual",
           "valid_actual", "date_validated",
           "validation_level", "units", "value")]
    return(df)

  }
  data("stations_sinaica", package = "rsinaica", envir = environment())
  left_join(df, stations_sinaica[, c("station_id",
                                    "network_name",
                                    "network_code")],
            by = c("estacionesId" = "station_id"))
}
