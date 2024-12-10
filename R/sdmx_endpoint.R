#' Returns the base request object
#'
#' Returns the base request object
#' @param x An endpoint or an httr2 request object
#' @param ... saved for future use
#' @return a [httr2::request()] object
#' @export
sdmx_endpoint <- function(x, ...){
  UseMethod("sdmx_endpoint")
}

#' @export
sdmx_endpoint.default <- function(x, ...){
  if (is.null(x)){
    return(sdmx_endpoint.character("https://sdmx-api.beta.cbs.nl/rest"))
  }
  stop("sdmx_endpoint() is not implemented for objects of class ", class(x))
}

#' @export
sdmx_endpoint.character <- function(x, ...){
  httr2::request(x, ...)
}

#' @export
sdmx_endpoint.httr2_request <- function(x, ...){
  x
}
