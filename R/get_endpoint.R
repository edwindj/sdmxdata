#' Connect to a SDMX provider
#'
#' Connect to an SDMX provider
#' @param id character, id of one of the available `providers`.
#' @param language character, the language to use for the text used in the response.
#' @param singleton logical, if `TRUE` return the same object if it already exists
#' @param verbose logical, if `TRUE` print information about the dataflows.
#' @return a SDMXEndpoint object
#' @export
get_endpoint <- function(
    id,
    language = NULL,
    singleton = TRUE,
    verbose = FALSE
  ){
  # to keep CRAN check happy
  providers <- sdmxdata::providers

  id <- match.arg(id, choices = providers$id)
  idx <- match(id, providers$id)
  provider <- providers[idx,] |> as.list()

  if (isTRUE(singleton) && exists(provider$id, envir = .providers)){
    return(get(provider$id, envir = .providers))
  }

  prov <- SDMXEndpoint$new(
    provider$endpoint,
    id = provider$id,
    name = provider$name,
    language = language %||% provider$language,
    verbose = verbose
  )

  assign(provider$id, prov, envir = .providers)

  hashed_endpoint <- gsub("[^[:alnum:]]", "_", provider$endpoint)
  assign(hashed_endpoint, prov, envir = .providers)

  prov
}

# to store the singleton providers
.providers <- new.env()
