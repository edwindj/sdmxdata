# see https://github.com/sdmx-twg/sdmx-rest/blob/v1.5.0/v2_1/ws/rest/docs/rest_cheat_sheet.pdf

sdmx_get_data_json <- function(url){
  req <- httr2::request(url) |>
    httr2::req_headers(accept = "application/vnd.sdmx.data+json; version=2.0; charset=utf-8")

  resp <- httr2::req_perform(req)
  resp |> httr2::resp_body_json(simplifyDataFrame = TRUE)

}

sdmx_get_structure_json <- function(meta, simplifyDataFrame = TRUE){
  req <- httr2::request(meta) |>
    httr2::req_headers(accept = "application/vnd.sdmx.structure+json;version=1.0;urn=true")

  resp <-
    req |>
    httr2::req_perform()  |>
    httr2::resp_body_json(
      simplifyDataFrame = simplifyDataFrame
    )
  # application/vnd.sdmx.structure+json;version=1.0;urn=true
  resp
}


get_csv <- function(url, labels = TRUE, file = FALSE){
  f <- tempfile("cbsopendata", fileext = ".csv")

  accept <- c(
    "application/vnd.sdmx.data+csv",
    "version=2.0", "charset=utf-8",
    #if(labels==FALSE) "labels=id" else "labels=both",
    if(file==TRUE) "file=true"
  ) |> paste(collapse = ";")

  req <- httr2::request(url) |>
    httr2::req_headers(
      accept = accept
  )

  resp <- httr2::req_perform(req, path = f)
  cat(readLines(f))
  data.table::fread(f)
}
