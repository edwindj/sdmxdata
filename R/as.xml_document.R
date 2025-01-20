#' Get data from a SDMX API
#'
#' Retrieve data from an sdmx api and return it as an xml_document
#' @param x An httr2 request object
#' @param ... reserved for future use
#' @param cache_dir The directory to cache the request in, set to `NULL` to disable caching
#' @param verbose if `TRUE` print information about the caching.
#' @return a `xml2::xml_document` object
#' @example example/sdmx_v2_1_as_xml.R
#' @importFrom xml2 as_xml_document
#' @export
as_xml_document.sdmx_v2_1_structure_request <- function(
    x,
    ...,
    cache_dir = tempdir(),
    verbose = getOption("sdmxdata.verbose", FALSE)
){
  req <- x
  doc <- cache_xml(req, cache_dir = cache_dir, verbose = verbose)
  # path <- tempfile("sdmx", fileext = ".xml")
  # resp <- req |>
  #   httr2::req_perform(path = path)
  #
  # doc <- xml2::read_xml(path)
  doc
}
