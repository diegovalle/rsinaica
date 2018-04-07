
<!-- README.md is generated from README.Rmd. Please edit that file -->
rsinaica
========

[![Travis-CI Build Status](https://travis-ci.org/diegovalle/rsinaica.svg?branch=master)](https://travis-ci.org/diegovalle/rsinaica) [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/p281myk561l2kxgt?svg=true)](https://ci.appveyor.com/project/diegovalle/rsinaica/branch/master) [![Coverage Status](https://img.shields.io/codecov/c/github/diegovalle/rsinaica/master.svg)](https://codecov.io/github/diegovalle/rsinaica?branch=master) [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-red.svg)](https://www.tidyverse.org/lifecycle/#experitmental) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version-ago/rsinaica?color=red)]()

Ready-made functions for downloading air quality data from the Mexican National Air Quality Information System (SINAICA).

Installation
------------

rsinaica is not currently available from CRAN, but you can install the development version from github with:

``` r
if (!require(devtools)) {
    install.packages("devtools")
}
devtools::install_github('diegovalle/rsinaica')
```

<!--ou can install the released version of rsinaica from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("rsinaica")
```-->
Example
-------

Suppose you wanted to download pollution data from the 'Centro' station in Guadalajara. First we load the package and look up the numeric code for the station in the `stations_sinaica` data.frame:

``` r
library("rsinaica")
library("ggplot2")

knitr::kable(stations_sinaica[which(stations_sinaica$station_name == "Centro"), 1:6])
```

|     |  station\_id| station\_name | station\_code |  network\_id| network\_name  | network\_code |
|-----|------------:|:--------------|:--------------|------------:|:---------------|:--------------|
| 12  |           33| Centro        | CEN           |           30| Aguascalientes | AGS           |
| 42  |           54| Centro        | CEN           |           38| CHIH1          | CHIH1         |
| 75  |          102| Centro        | CEN           |           63| Guadalajara    | GDL           |

The station Centro located in Guadalajara has a numeric code of 102 (station\_id). The `stations_sinaica` data.frame also includes the latitude and longitude of all the measuring stations in Mexico (including some that have never reported any data!).

``` r
mx <- map_data("world", "Mexico")
stations_sinaica$color <- "Others"
stations_sinaica$color[stations_sinaica$station_id == 102] <- "Centro"
ggplot(stations_sinaica[order(stations_sinaica$color, decreasing = TRUE),], aes(lon, lat)) + 
  geom_polygon(data = mx, aes(x= long, y = lat, group = group)) +
  geom_point(alpha = .9, size = 3, aes(fill = color), shape = 21) + 
  scale_fill_discrete("station") +
  ggtitle("Air quality measuring stations in Mexico") +
  coord_map() + 
  theme_void()
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

Then we query the dates during which the station has been in operation:

``` r
get_station_dates(102)
#> [1] "1997-01-01" "2018-04-07"
```

It's currently reporting data, and has been doing so since 1997. We can also query which type of parameters (pollution, wind, solar radiation, etc) the station has sensors for. Note that the package also includes a `parameters` data.frame with all the supported parameters, but not all stations support all of them.

``` r
cen_params <- get_station_parameters(102)
knitr::kable(cen_params)
```

| parameter\_id | parameter\_name                 |
|:--------------|:--------------------------------|
| CN            | Carbono negro                   |
| SO2           | Dióxido de azufre               |
| NO2           | Dióxido de nitrógeno            |
| DV            | Dirección del viento            |
| HR            | Humedad relativa                |
| CO            | Monóxido de carbono             |
| NO            | Óxido nítrico                   |
| NOx           | Óxidos de nitrógeno             |
| O3            | Ozono                           |
| PM10          | Partículas menores a 10 micras  |
| PM2.5         | Partículas menores a 2.5 micras |
| PP            | Precipitación pluvial           |
| TMPI          | Temperatura interior            |
| VV            | Velocidad del viento            |

Finally, we can download and plot particulate matter data for the month of January

``` r
# Download all PM10 data for January 2018
df <-  sinaica_bystation(102, "PM10", "2018-01-01", "Crude", "1 month")

ggplot(df, aes(hour, value, group = date)) +
  geom_line(alpha=.9) +
  ggtitle(expression(paste(PM[10],
                           " pollution during January 2018 in Centro, Guadalajara, by hour"))) +
  xlab("hour") +
  ylab(expression(paste(mu,"g/", m^3))) +
  theme_bw()
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />
