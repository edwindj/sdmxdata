#  https://search.beta.cbs.nl/api/search?tenant=cbs
#' Get the search endpoint
#'
#' Get the search endpoint
#' @param x An endpoint or an httr2 request object
#' @param ... saved for future use
#' @return a [httr2::request()] object
#' @export
search_endpoint <- function(x, ...){
  UseMethod("search_endpoint")
}

#' @export
search_endpoint.default <- function(x, ...){
  return(search_endpoint.character("https://search.beta.cbs.nl/api/search?tenant=cbs"))
  stop("search_endpoint() is not implemented for objects of class ", class(x))
}

#' @export
search_endpoint.character <- function(x, ...){
  httr2::request(x, ...)
}

#' @export
search_endpoint.httr2_request <- function(x, ...){
  x
}
