#' Get data from a SDMX API
#'
#' Retrieve data from an sdmx api and return it as an xml_document
#' @param req An httr2 request object
#' @param ... reserved for future use
#' @return a `xml2::xml_document` object
#' @example example/sdmx_v2_1_as_xml.R
#' @export
sdmx_v2_1_as_xml <- function(
    req,
    ...
){
  path <- tempfile("sdmx", fileext = ".xml")
  resp <- req |>
    httr2::req_perform(path = path)

  doc <- xml2::read_xml(path)
  doc
}
