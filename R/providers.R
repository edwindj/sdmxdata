#' Connect to a SDMX provider
#'
#' Connect to an SDMX provider
#' @param provider character, one of the available providers
#' @param language character, the language to use for the text used in the response.
#' @param verbose logical, if `TRUE` print information about the dataflows.
#' @return a SDMXDataClient object\
#' @export
get_provider <- function(
    provider,
    language = NULL,
    verbose = FALSE
  ){

  provider <- match.arg(provider, choices = providers$id)
  idx <- match(provider, providers$id)
  provider <- providers[idx,] |> as.list()

  SDMXDataClient$new(
    provider$endpoint,
    id = provider$id,
    name = provider$name,
    language = language %||% provider$language,
    verbose = verbose
  )
}
