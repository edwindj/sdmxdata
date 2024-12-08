#' @export
get_search_request <- function(x, ...){
  UseMethod("get_search_request")
}

#' @export
get_search_request.default <- function(x, ...){
  return(get_base_request.character("https://sdmx-api.beta.cbs.nl/rest"))
  stop("get_base_request() is not implemented for objects of class ", class(x))
}

#' @export
get_search_request.character <- function(x, ...){
  httr2::request(x, ...)
}

#' @export
get_search_request.httr2_request <- function(x, ...){
  x
}
