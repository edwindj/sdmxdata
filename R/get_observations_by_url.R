#' Get observations using data-explorer url
#'
#' Retrieve observations using the url from the data-explorer. The url given
#' will be parsed and translated into a [get_observations()] call, to get you started.
#' The call will be printed to the console or can be retrieved by settings `return_query = TRUE`.
#' @param url character, the REST 2.1 url retrieved from an external source
#' @param return_query logical, if `TRUE` return the query object instead of the observation
#' @param verbose logical, if `TRUE` print information about the query
#' @return when `return_query = FALSE` a data.frame with the observations, i.e.
#' same output as [get_observations()]. Otherwise a list with the query object
#' and the parameters
#' @example example/get_observations_by_url.R
#' @export
get_observations_by_url <- function(url, return_query = FALSE, verbose = FALSE){
  res <- sdmx_parse_data_url(url, verbose = verbose)

  if (isTRUE(return_query)){
    return(res)
  }

  message("Retrieving data using the following statement:\n",
          paste0("  ", res$expr |> deparse() |> paste(collapse = "\n  "))
  )

  obs <- eval(res$expr)
  obs
}
