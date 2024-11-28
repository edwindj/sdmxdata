
get_json <- function(url){
  req <- httr2::request(url) |>
    httr2::req_headers(accept = "application/vnd.sdmx.data+json; version=2.0; charset=utf-8")


  resp <- httr2::req_perform(req)
  resp |> httr2::resp_body_json(simplifyDataFrame = TRUE)

}

get_meta_json <- function(meta){
  req <- httr2::request(meta) |>
    httr2::req_headers(accept = "application/vnd.sdmx.structure+json;version=1.0;urn=true")

  resp <-
    req |>
    httr2::req_perform()  |>
    httr2::resp_body_json()
  # application/vnd.sdmx.structure+json;version=1.0;urn=true
}


get_csv <- function(url){
  f <- tempfile("cbsopendata", fileext = ".csv")

  req <- httr2::request(url) |>
    httr2::req_headers(accept = "application/vnd.sdmx.data+csv; version=2.0; charset=utf-8")

  resp <- httr2::req_perform(req, path = f)
  read.csv(f)
}
