#' Get sdmx category schemes
#'
#' Get sdmx categoryschemes from a given endpoint.
#' @param endpoint an endpoint, url or [httr2::request()] object.
#' @param agencyID A character string from a given agencyID.
#' @param raw If `TRUE` return the raw data from the SDMX, otherwise the data is processed.
#' @param ... saved for future use.
#' @param language The language to use for the text used in the response.
#' @param cache_dir The directory to cache the request in, set to `NULL` to disable caching.
#' @param verbose if `TRUE` print information about the dataflows.
#' @return a data.frame with available dataflows
#' @example example/list_dataflows.R
#' @export
list_categoryschemes <- function(
    endpoint = NULL,
    agencyID = NULL,
    ...,
    language = "nl",
    cache = TRUE,
    raw = FALSE,
    verbose = getOption("sdmxdata.verbose", FALSE)
){
  endpoint <- sdmx_endpoint(endpoint)
  language <- language %||% endpoint$language
  # path <- tempfile("sdmx", fileext = ".json")

  agencyID <- if (is.null(agencyID)){
    NULL
  } else {
    agencyID |> paste0(collapse = "+")
  }

  req <-
    sdmx_v2_1_structure_request(
    endpoint = endpoint,
    resource = "categoryscheme",
    agencyID = agencyID,
    format = "json",
    language = language
  )

  cache_key <- "categoryschemes"
  if (!is.null(agencyID)){
    cache_key <- paste0(cache_key, "_", agencyID)
  }

  if (!is.null(language)){
    cache_key <- paste0(cache_key, "_", language)
  }

  res <- req |>
    cache_json(
      simplifyVector = !raw,
      key = cache_key,
      cache_dir = if (cache) endpoint$cache_dir else NULL,
      verbose = verbose
    )

  was_cached <- isTRUE(attr(res, "was_cached"))

  if (isTRUE(raw)){
    return(res)
  }
  # TODO provide a "raw" option that returns the full response of the SDMX v2.1 API
  categoryschemes <- res$data$categorySchemes

  # we add ref to the dataflows for convenience, to be used as a reference to a
  # dataflow
  categoryschemes$ref <- with(categoryschemes, {
      sprintf("%s:%s(%s)", agencyID, id, version)
  })

  categoryschemes <- categoryschemes |>
    ensure(c("agencyID", "id", "version", "name", "description", "ref"))

  # we add ref to the dataflows for convenience, to be used as a flowRef
  # dataflows$flowRef <- with(dataflows, {
  #   paste(agencyID, id, version, sep = ",")
  # })

  contentLanguages = res$meta$contentLanguages

if (verbose || (!was_cached && missing(verbose))){
  message(
"Available category schemes: ", nrow(categoryschemes), "\n",
"Agencies: ", unique(categoryschemes$agencyID) |> dQuote() |> paste(collapse = ", "), "\n",
"Content languages: ", contentLanguages |> dQuote() |> paste(collapse = ", ")
)
}

  categoryschemes |>
    structure(
      contentLanguages = contentLanguages
    )
}

