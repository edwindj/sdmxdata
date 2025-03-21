#' Create a new SDMX endpoint
#'
#' Create an endpoint from an url or httr2 request object
#' @param x An endpoint or an httr2 request object
#' @param ... saved for future use
#' @param id character, the id of the endpoint
#' @param name character, the name of the endpoint
#' @param language character, the language to use for the text used in the response
#' @param cache_dir character, the directory to cache the metadata in
#' @param verbose logical, if `TRUE` print information on the connection
#' @return a [SDMXEndpoint] object
#' @family SDMX endpoints
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
    return(sdmx_endpoint(endpoint, ...))
  }
  stop("sdmx_endpoint() is not implemented for objects of class ", class(x))
}

#' @export
#' @rdname sdmx_endpoint
sdmx_endpoint.character <- function(
    x,
    id = gsub("\\W+", "_", x),
    name = x,
    language = NULL,
    cache_dir = file.path(tempdir(), "sdmxdata", id),
    verbose = getOption("sdmxdata.verbose", FALSE),
    ...
  ){
  endpoint <- SDMXEndpoint$new(url = x, id = id, name = name, language = language, cache_dir = cache_dir, verbose = verbose)
  endpoint
}

#' @export
#' @rdname sdmx_endpoint
sdmx_endpoint.httr2_request <- function(x, ...){
  endpoint <- SDMXEndpoint$new(url = x$url, ...)
  endpoint$req <- x
  endpoint
}

#' @export
sdmx_endpoint.SDMXEndpoint <- function(x, ...){
  x
}
