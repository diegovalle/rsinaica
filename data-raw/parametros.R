library(httr)
library(jsonlite)

url = "http://sinaica.inecc.gob.mx/lib/j/php/getData.php"
fd <- list(
  tabla  = "Datos",
  fields = "DISTINCT parametro"
)
result <- POST(url,
               body = fd,
               encode = "form")
json_result <- content(result, "text", encoding = "UTF-8")
parameters <- fromJSON(json_result)
names(parameters) <- "parameter"

write.csv(parameters, "data-raw/parameters.csv", row.names = FALSE)
devtools::use_data(parameters, overwrite = TRUE)
