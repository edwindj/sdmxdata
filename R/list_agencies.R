#' list the agencies of an endpoint
#'
#' list the agencies of an endpoint
#' @export
#' @param endpoint an endpoint, url or an [httr2::request()] object
#' @param language the language to return the data in
#' @param raw if `TRUE` return the raw data
#' @param cache_dir the directory to cache the data in, set to `NULL` to disable caching
#' @param verbose if `TRUE` print information about the caching.
list_agencies <- function(
    endpoint = NULL,
    language = NULL,
    raw = FALSE,
    cache = TRUE
  ) {

  endpoint <- sdmx_endpoint(endpoint)
  req <- endpoint$req

  cache_key <- "agencies"
  if (is.character(language)) {
    cache_key <- paste0(cache_key, "_", language)
  }

  as <- sdmx_v2_1_structure_request(
    endpoint = endpoint,
    resource = "agencyscheme",
    language = language
  ) |>
  get_structure_from_json(
    cache_key = cache_key,
    cache_dir = if (isTRUE(cache)) endpoint$cache_dir else NULL,
    verbose = endpoint$verbose
  )

  if (isTRUE(raw)){
    return(as)
  }

  schemes <- as$data$agencySchemes
  agencies <- schemes$agencies |>
    lapply(function(agencies){
      agencies$ref <- agencies |> extract_self_urn() |> strip_urn()
      agencies |> ensure(c("id", "name", "description", "ref"))
    })

  do.call(rbind, agencies)
}
