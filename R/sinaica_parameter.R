
#' Get data for all stations by parameter
#'
#' @param parameter type of
#' @param start_date start date
#' @param end_date end date
#' @param autoclean clean the data automatically
#'
#' @return data.frame with air quality data
#' @importFrom httr POST http_error content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr left_join
#' @importFrom lubridate day<- days_in_month
#' @importFrom utils data
#' @export
sinaica_parameter <- function(parameter = c("BEN", "CH4", "CN", "CO", "CO2", "DV",
                                            "H2S", "HCNM", "HCT",
                                            "HR", "HRI", "IUV", "NO", "NO2",
                                            "NOx",
                                            "O3", "PB", "PM10",
                                            "PM2.5", "PP", "PST", "RS", "SO2",
                                            "TMP", "TMPI", "UVA", "UVB",
                                            "VV", "XIL"),
                              start_date, end_date,
                              autoclean = TRUE) {
  if (!is.Date(start_date))
    stop("start_date should be in YYYY-MM-DD format", call. = FALSE)
  if (!is.Date(end_date))
    stop("end_date should be in YYYY-MM-DD format", call. = FALSE)
  parameter <- match.arg(parameter)
  if( start_date > end_date)
    stop("start_date should be less than or equal to end_date")

  d <- as.Date(start_date)
  day(d) <- days_in_month(d)
  if (as.Date(end_date) > d)
    stop("The maximum amount of data you can download is 1 month",
         call. = FALSE)

  url = "http://sinaica.inecc.gob.mx/lib/j/php/getData.php"
  fd <- list(
    tabla  = "Datos",
    fields = "",
    where  = paste0("parametro = '", parameter, "' and fecha >= '", start_date,
                    "' and fecha <= '", end_date, "'")
  )

  result <- POST(url,
                 body = fd,
                 encode = "form")
  html_text <- content(result, "text", encoding = "UTF-8")
  df <- fromJSON(html_text)
  limPerm <- switch(parameter, PM10 = 600, PM2.5 = 175, NO2 = .21,
                    SO2 = .2, CO = 15,
                    O3 = .2, 10000000000)
  if(identical(autoclean, TRUE)) {
    df$value <- df$valorAct
    df$value <- as.numeric(df$value)
    df$value[which(!is.finite(df$value))] <- NA
    df$value[which(df$validoAct == 0)] <- NA
    df$value[which(df$value < 0)] <- NA
    df$value[which(df$value > limPerm)] <- NA
  }
  df$estacionesId <- as.integer(df$estacionesId)

  data("stations_sinaica", package="rsinaica", envir=environment())
  left_join(df, stations_sinaica[,c("station_id",
                                    "network_name",
                                    "network_code")],
            by = c("estacionesId" = "station_id"))
}

