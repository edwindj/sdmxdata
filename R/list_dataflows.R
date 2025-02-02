#' List available sdmx dataflows
#'
#' List the sdmx dataflows from a given endpoint.
#' @param endpoint A character string or endpoint for a given endpoint.
#' @param agencyID A character string from a given agencyID.
#' @param raw If `TRUE` return the raw data from the SDMX, otherwise the data is processed.
#' @param ... saved for future use.
#' @param language The language to use for the text used in the response.
#' @param cache if `TRUE` cache the list of dataflows
#' @param verbose if `TRUE` print information about the dataflows.
#' @return a data.frame with available dataflows
#' @example example/list_dataflows.R
#' @export
list_dataflows <- function(
    endpoint = NULL,
    agencyID = NULL,
    ...,
    language = NULL,
    cache = TRUE,
    raw = FALSE,
    verbose = getOption("sdmxdata.verbose", FALSE)
){
  endpoint <- sdmx_endpoint(endpoint)
  language <- language %||% endpoint$language
  verbose <- verbose | endpoint$verbose
  cache_dir <- if (cache) endpoint$cache_dir else NULL
  req <- endpoint$req

  # path <- tempfile("sdmx", fileext = ".json")

  agencyID <- if (is.null(agencyID)){
    NULL
  } else {
    agencyID |> paste0(collapse = "+")
  }

  req <- sdmx_v2_1_structure_request(
    endpoint = endpoint,
    resource = "dataflow",
    agencyID = agencyID,
    format = "json",
    language = language
  )

  if (verbose){
    print(req)
  }

  cache_key <- "dataflows"
  if (!is.null(agencyID)){
    cache_key <- paste0(cache_key, "_", agencyID)
  }

  if (!is.null(language)){
    cache_key <- paste0(cache_key, "_", language)
  }

  res <- req |>
    cache_json(
      simplifyVector = TRUE,
      key = cache_key,
      cache_dir = cache_dir,
      verbose = verbose
    )

  was_cached <- isTRUE(attr(res, "was_cached"))

  # "raw" option returns the full response of the SDMX v2.1 API
  if (isTRUE(raw)){
    return(res)
  }

  dataflows <- res$data$dataflows

  # we add ref to the dataflows for convenience, to be used as a reference to a
  # dataflow
  dataflows$ref <- with(dataflows, {
      sprintf("%s:%s(%s)", agencyID, id, version)
  })

  dataflows <- dataflows |>
    ensure(c("agencyID", "id", "version", "name", "description", "ref"))

  # we add ref to the dataflows for convenience, to be used as a flowRef
  # dataflows$flowRef <- with(dataflows, {
  #   paste(agencyID, id, version, sep = ",")
  # })

  contentLanguages = res$meta$contentLanguages

if (verbose || (!was_cached && missing(verbose))){
  message(
"Available dataflows: ", nrow(dataflows), "\n",
"Agencies: ", unique(dataflows$agencyID) |> dQuote() |> paste(collapse = ", "), "\n",
"Content languages: ", contentLanguages |> dQuote() |> paste(collapse = ", ")
)
}

  dataflows |>
    structure(
      contentLanguages = contentLanguages,
      class = c("sdmx_v2_1_dataflows", class(dataflows))
    )
}

