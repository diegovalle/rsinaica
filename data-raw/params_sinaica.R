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
params_sinaica <- fromJSON(json_text)
params_sinaica$descripcion <- NULL
params_sinaica$tipoParametro <- NULL
names(params_sinaica) <- c("param_code", "param_name")
Encoding(params_sinaica$param_name) <- "UTF-8"

write.csv(params_sinaica, "data-raw/params_sinaica.csv", row.names = FALSE)
devtools::use_data(params_sinaica, overwrite = TRUE)
