context("test-stations_sinaica.R")

# No duplicate stations in data.frame
test_that("sinaica_station_data returns correct data", {
  expect_false(any(duplicated(stations_sinaica$station_id)))
})


test_that(paste0("Check that no new stations have been added to SINAICA ",
                 "since we updated stations_sinaica"),
{
  skip_on_cran()
  skip_on_ci()
  library("httr")
  library("jsonlite")
  library("dplyr")
  library("rsinaica")
  # Download a station list from the SINAICA website
  get_latest_estaciones <- function() {

    url <- "https://sinaica.inecc.gob.mx/lib/libd/cnxn.php"

    response <- POST(
      url,
      body = list(metodo = "getUltimosEnvios"),
      encode = "form"
    )

    stop_for_status(response)

    fromJSON(content(response, as = "text", encoding = "UTF-8"))
  }

  latest_ids <- get_latest_estaciones()


  get_estaciones_sinaica <- function(type) {
    url <- "https://sinaica.inecc.gob.mx/lib/j/php/getData.php"
    fd <- list(
      tabla  = "Estaciones e INNER JOIN Redes r ON e.redesid = r.id",
      fields = paste0("e.id, e.nombre, e.codigo, ",
                      "e.redesId, r.nombre as nombre_red,",
                      "r.codigo as codigo_red, e.calle, e.ext, e.interior, ",
                      "e.colonia, e.cp, e.estadoId, ",
                      "e.municipioId, e.adquisicion, ",
                      "e.elevacion, e.direccion, ",
                      "e.fechaValid, e.fechaValidAnt,",
                      "e.pasoVal, e.video, e.lat, e.long, ",
                      "e.fechaIniDatos, e.zonaHoraria,",
                      "e.streetView, e.videoInt"),
      where  = "1=1 ORDER BY r.nombre, e.codigo"
    )

    result <- POST(url,
                   ## remove this it's very unsafe
                   config = config(ssl_verifypeer = F, ssl_verifyhost=F),
                   body = fd,
                   encode = "form")
    html_text <- content(result, "text", encoding = "UTF-8")
    fromJSON(html_text)
  }
  stations_sinaica_latest <- get_estaciones_sinaica()

  names(stations_sinaica_latest) <- c("station_id",
                                      "station_name",
                                      "station_code",
                                      "network_id",
                                      "network_name",
                                      "network_code",
                                      "street",
                                      "ext",
                                      "interior",
                                      "colonia",
                                      "zip",
                                      "state_code",
                                      "municipio_code",
                                      "year_started",
                                      "altitude",
                                      "address",
                                      "date_validated",
                                      "date_validated2",
                                      "passed_validation",
                                      "video",
                                      "lat",
                                      "lon",
                                      "date_started",
                                      "timezone",
                                      "street_view",
                                      "video_interior")

  # Compare the stations we downloaded with those from the
  # SINAICA website
  diffs <- setdiff(latest_ids$idEstacion,
                   stations_sinaica_latest$station_id)
  stopifnot(length(diffs) == 0)

  # filter an R data frame such that the values in one of its columns match the
  # values in a column of another data frame using the base R %in% operator
  stations_sinaica_latest <-
    stations_sinaica_latest[which(c(stations_sinaica_latest$station_id  %in%
                                      latest_ids$idEstacion)), ]


  result <- anti_join(stations_sinaica_latest, stations_sinaica,
                      by = "station_id")
  expect_equal(nrow(result),
               0,
               info = paste(nrow(result),
                            " stations have been added to SINAICA"))
})
