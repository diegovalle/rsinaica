#' Air quality measuring stations in Mexico
#'
#' @description
#' This data set contains all the stations that report to the National
#' Air Quality Information System
#' \href{http://http://sinaica.inecc.gob.mx>}{SINAICA}.
#'
#' @format A data frame with 341 rows and 26 variables:
#' \describe{
#'   \item{station_id}{INEGI code of the region (state_code + municipio_code)}
#'   \item{station_name}{INEGI code of the state}
#'   \item{station_code}{state abbreviation}
#'   \item{network_id}{INEGI code of the municipio}
#'   \item{network_name}{name of the municipio}
#'   \item{network_code}{zone}
#'   \item{street}{zone}
#'   \item{ext}{zone}
#'   \item{interior}{zone}
#'   \item{colonia}{zone}
#'   \item{zip}{zone}
#'   \item{state_code}{zone}
#'   \item{municipio_code}{zone}
#'   \item{year_started}{zone}
#'   \item{altitude}{zone}
#'   \item{address}{zone}
#'   \item{date_validated}{zone}
#'   \item{date_validated2}{zone}
#'   \item{passed_validation}{zone}
#'   \item{video}{zone}
#'   \item{lat}{zone}
#'   \item{lon}{zone}
#'   \item{date_started}{zone}
#'   \item{timezone}{zone}
#'   \item{street_view}{zone}
#'   \item{video_interior}{zone}
#' }
#' @source \href{http://www.aire.cdmx.gob.mx/descargas/ultima-hora/calidad-aire/pcaa/Gaceta_Oficial_CDMX.pdf}{ Gaceta Oficial de la Ciudad de México}
#' No. 230, 27 de Diciembre de 2016, and
#' \emph{Solicitud de Información} FOLIO 0112000033818
#'
#' @docType data
#' @name stations_sinaica
#' @usage data(stations_sinaica)
#' @examples
#' head(stations_sinaica)
NULL

#' Valid air quality parameters
#'
#'
#'
#' @format A data frame with 30 rows and 1 variables:
#' \describe{
#'   \item{parameter}{Abbreviation of the air quality parameter}
#' }
#' @docType data
#' @name parameters
#' @examples
#' head(parameters)
NULL
