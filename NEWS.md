# rsinaica (development version)

* `sinaica_station_data` now supports downloading two years of data
* Remove duplicate stations from the `stations_sinaica` data.frame
* `sinaica_station_dates()` lists the dates for which a station has data available.
* `sinaica_station_params()` lists the air quality parameters measured at 
a station for which SINAICA provides data.

# rsinaica 1.1.1

* Update the `stations_sinaica` data.frame to include all the latest stations

# rsinaica 1.1.0

* Deprecate `sinaica_param_data` since the SINAICA website no longer supports 
downloading data from all stations at once.

# rsinaica 1.0.0

* Use latest version of roxygen to generate documentation

# rsinaica 0.6.1

* `sinaica_station_dates()` and `sinaica_param_data()` return NULL when SINAICA is down

# rsinaica 0.6.0

* Changed the web address of the sinaica server to use https

# rsinaica 0.5.0

* First release
* Added functions `sinaica_param_data()` and `sinaica_station_data()` to download air quality data
* Added functions `sinaica_station_dates()` and `sinaica_station_params()` to query station metadata
* Added data.frames `stations_sinaica` and `params_sinaica`
* Added a `NEWS.md` file to track changes to the package.
