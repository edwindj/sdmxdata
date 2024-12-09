#  https://search.beta.cbs.nl/api/search?tenant=cbs
#' Get the search endpoint
#'
#' Get the search endpoint
#' @param x An endpoint or an httr2 request object
#' @param ... saved for future use
#' @return a [httr2::request()] object
#' @export
search_request <- function(x, ...){
  UseMethod("search_request")
}

#' @export
search_request.default <- function(x, ...){
  return(search_request.character("https://search.beta.cbs.nl/api/search?tenant=cbs"))
  stop("search_request() is not implemented for objects of class ", class(x))
}

#' @export
search_request.character <- function(x, ...){
  httr2::request(x, ...)
}

#' @export
search_request.httr2_request <- function(x, ...){
  x
}
