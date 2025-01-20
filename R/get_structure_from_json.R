# see https://github.com/sdmx-twg/sdmx-rest/blob/v1.5.0/v2_1/ws/rest/docs/rest_cheat_sheet.pdf
get_structure_from_json <- function(
    req,
    simplifyVector = TRUE,
    ...,
    cache_dir = tempdir(),
    cache_key = req$url,
    verbose = getOption("sdmxdata.verbose", FALSE)
    ){

  req <- req |>
    httr2::req_headers(accept = "application/vnd.sdmx.structure+json;version=1.0;urn=true")

  res <- cache_json(req, key = cache_key, cache_dir = cache_dir, verbose = verbose)
  res
}
