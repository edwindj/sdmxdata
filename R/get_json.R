# see https://github.com/sdmx-twg/sdmx-rest/blob/v1.5.0/v2_1/ws/rest/docs/rest_cheat_sheet.pdf

get_json <- function(url){
  req <- httr2::request(url) |>
    httr2::req_headers(accept = "application/vnd.sdmx.data+json; version=2.0; charset=utf-8")


  resp <- httr2::req_perform(req)
  resp |> httr2::resp_body_json(simplifyDataFrame = TRUE)

}

get_structure_from_json <- function(
    req,
    simplifyVector = TRUE,
    ...,
    cache_dir = tempdir(),
    verbose = getOption("cbsopendata.verbose", FALSE)
    ){

  req <- req |>
    httr2::req_headers(accept = "application/vnd.sdmx.structure+json;version=1.0;urn=true")

  res <- cache_json(req, cache_dir = cache_dir, verbose = verbose)
  res
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
