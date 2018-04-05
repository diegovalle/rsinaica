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
parameters <- fromJSON(json_text)
parameters$descripcion <- NULL
parameters$tipoParametro <- NULL
names(parameters) <- c("parameter_code", "parameter_name")
Encoding(parameters$parameter_name) <- "UTF-8"

write.csv(parameters, "data-raw/parameters.csv", row.names = FALSE)
devtools::use_data(parameters, overwrite = TRUE)
