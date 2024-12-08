#' @export
sdmx_data_request <- function(
    req = NULL,
    resource = c("data", "metadata"),
    flowRef = NULL,
    key = NULL,
    providerRef = NULL,
    format = c("csv", "json", "xml"),
    ...,
    startPeriod = NULL,
    endPeriod = NULL,
    updatedAfter = NULL,
    firstNObservations = NULL,
    lastNObservations = NULL,
    dimensionAtObservation = NULL,
    detail = c("full", "dataonly", "serieskeysonly", "nodata"),
    includeHistory = NULL){
  req <- get_base_request(req)
  resource <- match.arg(resource)

  path <- c(
    resource,
    flowRef,
    key,
    providerRef
  ) |>
    lapply(function(x) if (length(x)){paste(x, collapse = "+")}) |>
    paste(collapse = "/")

  req <- req |> httr2::req_template("GET /{path}")

    if (missing(detail)){
    detail <- NULL
  }

  if (!is.null(detail)){
    detail <- match.arg(detail)
  }

  req <- req |>
    httr2::req_url_query(
      startPeriod            = startPeriod,
      endPeriod.             = endPeriod,
      updatedAfter           = updatedAfter,
      firstNObservations     = firstNObservations,
      lastNObservations      = lastNObservations,
      dimensionAtObservation = dimensionAtObservation,
      detail                 = detail,
      includeHistory         = includeHistory
    )

  format <- match.arg(format)

  req <- switch(
    format,
    csv  = req |> httr2::req_headers(accept = "application/vnd.sdmx.data+csv; version=1.0.0; charset=utf-8"),
    json = req |> httr2::req_headers(accept = "application/vnd.sdmx.data+json; version=1.0.0; charset=utf-8"),
    xml  = req,
    req
  )

  req
}

# req <- httr2::request("https://sdmx-api.beta.cbs.nl/rest") |>
#   sdmx_rest_data_query(resource = "data")
