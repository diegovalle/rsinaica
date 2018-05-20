#' Air quality measuring stations in Mexico
#'
#' @description
#' This data set contains all the stations that report to the National
#' Air Quality Information System
#' \href{http://sinaica.inecc.gob.mx}{SINAICA}.
#'
#' @format A data frame with 341 rows and 26 variables:
#' \describe{
#'   \item{station_id}{Numeric code of the station}
#'   \item{station_name}{Name of the station}
#'   \item{station_code}{Abbreviation of the station}
#'   \item{network_id}{Numeric code for the network}
#'   \item{network_name}{Name of the network}
#'   \item{network_code}{Abbreviation of the network}
#'   \item{street}{street}
#'   \item{ext}{exterior number}
#'   \item{interior}{interior number}
#'   \item{colonia}{colonia}
#'   \item{zip}{zip code}
#'   \item{state_code}{state code}
#'   \item{municipio_code}{municipio code}
#'   \item{year_started}{date the station started operations}
#'   \item{altitude}{altitude in meters}
#'   \item{address}{address}
#'   \item{date_validated}{last date the station was validated}
#'   \item{date_validated2}{second to last date the station was validated}
#'   \item{passed_validation}{did the station pass validation}
#'   \item{video}{link to video of the station}
#'   \item{lat}{latitude}
#'   \item{lon}{longitude}
#'   \item{date_started}{date the station started operations}
#'   \item{timezone}{time zone in which the station is located (may contain errors)}
#'   \item{street_view}{link to Google Street View}
#'   \item{video_interior}{link to video of the interior of the station}
#' }
#' @docType data
#' @source \href{http://sinaica.inecc.gob.mx/}{SINAICA} ans Solicitud de Información 1612100005118
#' @name stations_sinaica
#' @usage data(stations_sinaica)
#' @examples
#' head(stations_sinaica)
NULL

#' Valid air quality parameters
#'
#'
#'
#' @format A data frame with 55 rows and 2 variables:
#' \describe{
#'   \item{param_code}{Abbreviation of the air quality parameter}
#'   \item{param_name}{Name of the air quality parameter}
#' }
#' @docType data
#' @name params_sinaica
#' @source \href{http://sinaica.inecc.gob.mx/}{SINAICA}
#' @examples
#' head(params_sinaica)
NULL
