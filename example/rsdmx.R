
url <- "https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/MIG/TOT../all?startPeriod=2011&endPeriod=2011"

xml <- rsdmx::readSDMX(url)
stats <- as.data.frame(sdmx)
head(stats)

library(httr2)
req <- httr2::request(url)

req |>
  httr2::req_headers(accept = "application/vnd.sdmx.data+csv; version=1.0.0; charset=utf-8") |>
  req_perform(path = "example/oecd.csv")

d <- data.table::fread("example/oecd.csv")
