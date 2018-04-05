#' Parameters supported by a station
#'
#' @param station_id numeric code of the station
#' @param type The type of data to download. One of the following:
#' \itemize{
#'  \item{"C"}{ - Crude data that has not been validated}
#'  \item{"V"}{ - Validated data}
#'  \item{"M"}{ - Manual data}
#' }
#'
#' @return a data.frame with the parameters supported by the station
#' @importFrom httr POST http_error http_type content status_code
#' @importFrom jsonlite fromJSON
#' @export
#'
#' @examples
#' df <- get_station_parameters(271, "C")
#' head(df)
get_station_parameters <- function(station_id,
                           type = c("C", "V", "M")
) {
  #curl 'http://sinaica.inecc.gob.mx/lib/libd/cnxn.php'
  # estId=33&metodo=getParamsPorEstAjax&tipoDatos=''
  type <- match.arg(type)
  if (type == "C")
    type <- ""
  url <- "http://sinaica.inecc.gob.mx/lib/libd/cnxn.php"
  fd <- list(
    estId     = station_id,
    metodo    = "getParamsPorEstAjax",
    tipoDatos = type
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
  df <- fromJSON(json_text)
  names(df) <- c("parameter_id", "parameter_name")
  df
}

#' Dates supported by a station
#'
#' @param station_id numeric code of the station
#' @param type The type of data to download. One of the following:
#' \itemize{
#'  \item{"C"}{ - Crude data that has not been validated}
#'  \item{"V"}{ - Validated data}
#'  \item{"M"}{ - Manual data}
#' }
#'
#' @return a vector containing the date the station started reporting
#' and end reporting date
#' @importFrom httr POST http_error http_type content status_code
#' @importFrom jsonlite fromJSON
#' @export
#'
#' @examples
#' df <- get_station_dates(271, "M")
#' head(df)
get_station_dates <- function(station_id,
                      type = c("C", "V", "M")
) {
  #curl 'http://sinaica.inecc.gob.mx/lib/libd/cnxn.php'
  # id=31&metodo=getFechasLimiteEstacionAjax&tipoDatos=
  type <- match.arg(type)
  if (type == "C")
    type <- ""
  url <- "http://sinaica.inecc.gob.mx/lib/libd/cnxn.php"
  fd <- list(
    id        = station_id,
    metodo    = "getFechasLimiteEstacionAjax",
    tipoDatos = type
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
  df <- fromJSON(json_text)
  df
}
