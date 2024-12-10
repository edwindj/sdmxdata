sdmx_req_data_from_url <- function(x){
  s <- sdmx_parse_data_url(x)
  print(s)
  eval(s$expr)
}


# url <- "https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/NAMA_10_GDP/A.CP_MEUR.B1GQ.BE+LU"
# req <- url |> sdmx_req_data_from_url()
#
# req |> httr2::req_perform(path = "example/oecd.csv")
