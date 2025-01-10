#' @export
download_to <- function(x, destfile, ...) {
  UseMethod("download_to")
}

#'@export
download_to.httr2_request <- function(x, destfile, ...) {
  path <- destfile
  httr2::req_perform(x, path = path)
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
