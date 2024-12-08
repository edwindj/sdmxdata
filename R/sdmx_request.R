#' Returns the base request object
#'
#' Returns the base request object
#' @param x An endpoint or an httr2 request object
#' @param ... saved for future use
#' @return a [httr2::request()] object
#' @export
sdmx_request <- function(x, ...){
  UseMethod("sdmx_request")
}

#' @export
sdmx_request.default <- function(x, ...){
  return(sdmx_request.character("https://sdmx-api.beta.cbs.nl/rest"))
  stop("sdmx_request() is not implemented for objects of class ", class(x))
}

#' @export
sdmx_request.character <- function(x, ...){
  httr2::request(x, ...)
}

#' @export
sdmx_request.httr2_request <- function(x, ...){
  x
}
