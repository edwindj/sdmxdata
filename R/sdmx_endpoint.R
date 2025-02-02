#' Returns the base request object
#'
#' Returns the base request object
#' @param x An endpoint or an httr2 request object
#' @param ... saved for future use
#' @return a [SDMXEndpoint] object
#' @export
sdmx_endpoint <- function(x, ...){
  UseMethod("sdmx_endpoint")
}

#' @export
sdmx_endpoint.default <- function(x, ...){
  if (is.null(x)){
    endpoint <- getOption("sdmxdata.endpoint", "https://sdmx-api.beta.cbs.nl/rest")
    if (is.null(endpoint)){
      stop("No endpoint provided, please provide an endpoint or set the default endpoint with options(sdmxdata.endpoint = 'http://example.com')")
    }
    return(sdmx_endpoint.character(endpoint))
  }
  stop("sdmx_endpoint() is not implemented for objects of class ", class(x))
}

#' @export
sdmx_endpoint.character <- function(x, ...){
  endpoint <- SDMXEndpoint$new(url = x, ...)
  endpoint
}

#' @export
sdmx_endpoint.httr2_request <- function(x, ...){
  endpoint <- SDMXEndpoint$new(url = x$url, ...)
  endpoint$req <- x
  endpoint
}

#' @export
sdmx_endpoint.SDMXEndpoint <- function(x, ...){
  x
}
