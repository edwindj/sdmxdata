#' Get data from a SDMX API
#'
#' Retrieve data from an sdmx api and return it as a data.frame
#' @param x An httr2 request object
#' @param keep.rownames logical, not used
#' @param ... reserved for future use
#' @return data.table
#' @example example/as.data.frame.R
#' @export
as.data.table.sdmx_v2_1_data_request <- function(
    x,
    keep.rownames = FALSE,
    ...
){
  req <- x
  req <- req |>
      httr2::req_headers(accept = "application/vnd.sdmx.data+csv; version=2.0.0; charset=utf-8") |>
      httr2::req_url_query(format="csv")  # for ESTAT it seems format="SDMX-CSV" is required

  path <- tempfile("sdmx", fileext = ".csv")

  resp <- req |>
    httr2::req_error(
      is_error = function(x) {
        if (x$status_code == 404){
          message("** Empty data selection, you may need to adjust your query.")
          return(FALSE)
        }
        return(FALSE)
      }
    ) |>
    httr2::req_perform(path = path)

  # shitty rest interface: when selection is empty, it returns a 404 (error)
  # and not an empty dataset
  if (resp$status_code == 404){
    return(
      as.data.table(NULL)
    )
  }

  d <- data.table::fread(file = path, colClasses = "character")
  d
}
