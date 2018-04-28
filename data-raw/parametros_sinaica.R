library(httr)
library(jsonlite)

url <- "http://sinaica.inecc.gob.mx/lib/j/php/getData.php"
fd <- list(
  tabla   = "Parametros"
)
result <- POST(url,
               body = fd,
               encode = "form")
json_text <- content(result, "text", encoding = "UTF-8")
parameters_sinaica <- fromJSON(json_text)
parameters_sinaica$descripcion <- NULL
parameters_sinaica$tipoParametro <- NULL
names(parameters_sinaica) <- c("parameter_code", "parameter_name")
Encoding(parameters_sinaica$parameter_name) <- "UTF-8"

write.csv(parameters_sinaica, "data-raw/parameters_sinaica.csv", row.names = FALSE)
devtools::use_data(parameters_sinaica, overwrite = TRUE)
