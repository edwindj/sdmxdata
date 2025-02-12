#' Connect to a SDMX endpoint
#'
#' Connect to an SDMX endpoint
#' @param id character, id of one of the available `endpoints`.
#' @param language character, the language to use for the text used in the response.
#' @param singleton logical, if `TRUE` return the same object if it already exists
#' @param verbose logical, if `TRUE` print information about the dataflows.
#' @return a SDMXEndpoint object
#' @example example/endpoints.R
#' @family SDMX endpoints
#' @export
get_endpoint <- function(
    id,
    language = NULL,
    singleton = TRUE,
    verbose = FALSE
  ){
  # to keep CRAN check happy
  endpoints <- sdmxdata::endpoints

  id <- match.arg(id, choices = endpoints$id)
  idx <- match(id, endpoints$id)
  endpoint <- endpoints[idx,] |> as.list()

  if (isTRUE(singleton) && exists(endpoint$id, envir = .endpoints)){
    return(get(endpoint$id, envir = .endpoints))
  }

  endpoint <- SDMXEndpoint$new(
    endpoint$url,
    id = endpoint$id,
    name = endpoint$name,
    language = language %||% endpoint$language,
    verbose = verbose
  )

  assign(endpoint$id, endpoint, envir = .endpoints)

  hashed_endpoint <- gsub("[^[:alnum:]]", "_", endpoint$url)
  assign(hashed_endpoint, endpoint, envir = .endpoints)

  endpoint
}

# to store the singleton endpoints
.endpoints <- new.env()
