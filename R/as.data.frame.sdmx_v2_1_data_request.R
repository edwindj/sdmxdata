#' Transform a SDMX data request into a data.frame
#'
#' Retrieve data from an sdmx api and return it as a data.frame
#' @param x An [sdmx_v2_1_data_request()] object
#' @param row.names Not used
#' @param optional Not used
#' @param ... reserved for future use
#' @return a data.frame
#' @example example/as.data.frame.R
#' @export
as.data.frame.sdmx_v2_1_data_request <- function(
    x,
    row.names = NULL,
    optional = FALSE,
    ...
){
  df <- as.data.table.sdmx_v2_1_data_request(x,...)
  data.table::setDF(df)
  df
}
