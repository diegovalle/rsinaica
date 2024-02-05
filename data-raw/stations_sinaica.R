
library("curl")
library("httr")
library("jsonlite")
library("dplyr")
library("rvest")
library("rsinaica")

get_stations_sinaica <- function()
{
  url <- 'https://api.datos.gob.mx/v2/sinaica-estaciones?pageSize=5000'
  result = GET(url)
  json_text <- content(result, "text", encoding = "UTF-8")
  o <- fromJSON(json_text)
  df <- data.frame(o$result)
  df <- df %>% rename(
    station_id = id,
    station_name = nombre,
    station_code = codigo,
    lat = lat,
    lon = long) %>%
    select(station_id, station_name, station_code, lat, lon)
  df
}
df <- get_stations_sinaica()


get_estaciones_sinaica <- function(type) {
  url = "https://sinaica.inecc.gob.mx/lib/j/php/getData.php"
  fd <- list(
    tabla  = "Estaciones e INNER JOIN Redes r ON e.redesid = r.id",
    fields = paste0("e.id, e.nombre, e.codigo, e.redesId, r.nombre as nombre_red,",
                    "r.codigo as codigo_red, e.calle, e.ext, e.interior, ",
                    "e.colonia, e.cp, e.estadoId, e.municipioId, e.adquisicion, ",
                    "e.elevacion, e.direccion, e.fechaValid, e.fechaValidAnt,",
                    "e.pasoVal, e.video, e.lat, e.long, e.fechaIniDatos, e.zonaHoraria,",
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
stations_sinaica <- get_estaciones_sinaica()
names(stations_sinaica) <- c("station_id",
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

diffs <- setdiff(df[, c("station_id", "lat", "lon")],
        stations_sinaica[, c("station_id", "lat", "lon")])
stations_sinaica[which(stations_sinaica$station_id == diffs$station_id),
                 c("station_id", "lat", "lon")]

stations_sinaica$station_id <- as.integer(stations_sinaica$station_id)
stations_sinaica$network_id <- as.integer(stations_sinaica$network_id)
stations_sinaica$lat <- as.numeric(stations_sinaica$lat)
stations_sinaica$lon <- as.numeric(stations_sinaica$lon)
stations_sinaica$lon[stations_sinaica$lon > 90] <- -stations_sinaica$lon[stations_sinaica$lon > 90]
stations_sinaica$lat[stations_sinaica$station_code == "NTS"] <- 19.38889
stations_sinaica$lon[stations_sinaica$station_code == "NTS"] <- -99.01944

stations_sinaica$lat[stations_sinaica$lat == 0] <- NA_real_
stations_sinaica$lon[stations_sinaica$lon == 0] <- NA_real_

stations_sinaica$network_name[stations_sinaica$network_code == "CHIH1"] <- "Chihuahua"
stations_sinaica$network_name[stations_sinaica$network_code == "CHIH2"] <- "Chihuahua - Municipal"

#Trim whitespace
stations_sinaica <- stations_sinaica %>%
  mutate(station_name = trimws(station_name)) %>%
  mutate(station_code = trimws(station_code)) %>%
  mutate(network_name = trimws(network_name)) %>%
  mutate(network_code = trimws(network_code))
Encoding(stations_sinaica$station_name) <- "UTF-8"
Encoding(stations_sinaica$network_name) <- "UTF-8"
Encoding(stations_sinaica$colonia) <- "UTF-8"
Encoding(stations_sinaica$address) <- "UTF-8"


## Get the timezone of each station
for (i in stations_sinaica$station_id) {
  url <- paste0("https://sinaica.inecc.gob.mx/estacion.php?estId=", i)
  station_name <- url %>%
    read_html() %>%
    html_nodes("h3") %>%
    html_text()
  ## Make sure the station_id is in the database
  if (station_name == " Estación:  ()") {
    stations_sinaica$timezone[which(stations_sinaica$station_id == i)] <- NA_character_
    next()
  }
  timezone <- url %>%
    read_html() %>%
    html_nodes("table") %>%
    html_table()

  stations_sinaica$timezone[which(stations_sinaica$station_id == i)] <-
    timezone[[1]][which(timezone[[1]]$X1 == "Zona horaria:"), ]$X2
  print(timezone[[1]][which(timezone[[1]]$X1 == "Zona horaria:"), "X2"])
}

Encoding(stations_sinaica$timezone) <- "UTF-8"
write.csv(stations_sinaica, "data-raw/stations_sinaica.csv", row.names = FALSE)
usethis::use_data(stations_sinaica, overwrite = TRUE, compress = "xz")
