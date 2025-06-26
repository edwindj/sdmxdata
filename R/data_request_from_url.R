#' Create a data request from a URL
#'
#' This function creates a data request from a URL that contains the necessary parameters for an SDMX data request.
#' Note that this is a raw request. Most users are better off using [get_observations_from_url()] instead.
#' @param url A URL that contains the parameters for the data request, including flowRef.
#' @param ... Additional parameters to be passed to the data request.
#' @param verbose If `TRUE`, print information about the request.
#' @return An object of class [sdmx_v2_1_data_request()] that can be used to retrieve data.
#' @example example/data_request_from_url.R
#' @export
data_request_from_url <- function(url, ..., verbose = FALSE){
  s <- sdmx_parse_data_url(url)

  s$verbose = verbose
  if (is.null(s$flowRef)){
    stop("The URL must contain the flowRef parameter")
  }

  expr <- bquote(
    sdmx_v2_1_data_request(
      ..(s)
    ),
    splice = TRUE
  )

  if (isTRUE(verbose)){
    message("Creating data request using the following statement:\n",
            paste0("  ", expr |> deparse() |> paste(collapse = "\n  "))
    )
  }

  eval(expr)
}
