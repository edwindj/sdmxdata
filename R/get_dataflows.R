#' Get sdmx dataflows
#'
#' Get sdmx dataflows from a given endpoint.
#' @param req A character string for a given endpoint.
#' @param agencyID A character string from a given agencyID.
#' @param ... saved for future use.
#' @param cache_dir The directory to cache the request in, set to `NULL` to disable caching.
#' @param verbose if `TRUE` print information about the dataflows.
#' @return a data.frame with available dataflows
#' @example example/get_dataflows.R
#' @export
get_dataflows <- function(
    req = NULL,
    agencyID = NULL,
    ...,
    cache_dir = tempdir(),
    verbose = getOption("cbsopendata.verbose", FALSE)
){

  # path <- tempfile("sdmx", fileext = ".json")

  req <-
    sdmx_v2_1_structure_request(
    req = req,
    resource = "dataflow",
    agencyID = agencyID,
    format = "json"
  )

  res <- req |>
    cache_json(
      simplifyVector = TRUE,
      cache_dir = cache_dir,
      verbose = verbose
    )

  was_cached <- isTRUE(attr(res, "was_cached"))

  # TODO provide a "raw" option that returns the full response
  dataflows <- res$data$dataflows

  # we add ref to the dataflows for convenience, to be used as a flowRef
  dataflows$ref <- with(dataflows, {
      paste(agencyID, id, version, sep = ",")
  })

  contentLanguages = res$meta$contentLanguages

if (verbose || (!was_cached && missing(verbose))){
  message(
"Available dataflows (with versions): ", nrow(dataflows), "\n",
"Unique dataflows: ", dataflows$id |> unique() |> length(), "\n",
"Agencies: ", unique(dataflows$agencyID) |> sQuote() |> paste(collapse = ", "), "\n",
"Content languages: ", contentLanguages |> sQuote() |> paste(collapse = ", ")
)
}

  dataflows |>
    structure(
      contentLanguages = contentLanguages,
      class = c("sdmx_v2_1_dataflows", class(dataflows))
    )
}

