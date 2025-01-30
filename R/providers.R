#' Connect to a SDMX provider
#'
#' Connect to an SDMX provider
#' @param provider character, one of the available providers
#' @param language character, the language to use for the text used in the response.
#' @param singleton logical, if `TRUE` return the same object if it already exists
#' @param verbose logical, if `TRUE` print information about the dataflows.
#' @return a SDMXProvider object
#' @export
get_provider <- function(
    provider,
    language = NULL,
    singleton = TRUE,
    verbose = FALSE
  ){

  provider <- match.arg(provider, choices = providers$id)
  idx <- match(provider, providers$id)
  provider <- providers[idx,] |> as.list()

  if (isTRUE(singleton) && exists(provider$id, envir = .providers)){
    return(get(provider$id, envir = .providers))
  }

  prov <- SDMXProvider$new(
    provider$endpoint,
    id = provider$id,
    name = provider$name,
    language = language %||% provider$language,
    verbose = verbose
  )

  assign(provider$id, prov, envir = .providers)
  prov
}

# to store the singleton providers
.providers <- new.env()
