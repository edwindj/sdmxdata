#' Get data from a SDMX API
#'
#' Retrieve data from an sdmx api and return it as an xml_document
#' @param req An httr2 request object
#' @param ... reserved for future use
#' @param cache_dir The directory to cache the request in, set to `NULL` to disable caching
#' @return a `xml2::xml_document` object
#' @example example/sdmx_v2_1_as_xml.R
#' @export
sdmx_v2_1_as_xml <- function(
    req,
    ...,
    cache_dir = tempdir()
){
  doc <- cache_xml(req, cache_dir=cache_dir)
  doc
}
