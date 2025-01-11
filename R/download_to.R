#' Download the response of a request to a file
#'
#' Download the response of a request to a file
#'
#' Download the response of a request to a file, but allows for different
#' format specifications e.g. csv, json, xml
#'
#' @param x An httr2 request object
#' @param destfile A character string with the path to the file to save the response
#' @param ... saved for future use
#' @export
download_to <- function(x, destfile, ...) {
  UseMethod("download_to")
}

#'@export
download_to.httr2_request <- function(x, destfile, ...) {
  path <- destfile
  httr2::req_perform(x, path = path) |>
    invisible()
}

#'@export
download_to.sdmx_v2_1_data_request <- function(
    x,
    destfile,
    format = c("csv", "json", "xml"),
    ...
  ) {
  format <- match.arg(format)
  print(format)
  path <- destfile

  httr2::req_perform(x, path = path) |>
    invisible()
}
