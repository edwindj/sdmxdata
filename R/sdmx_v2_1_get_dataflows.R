#' Get sdmx dataflows
#'
#' Get sdmx dataflows from a given endpoint
#' @param req A character string from a given endpoint
#' @param agencyID A character string from a given agencyID
#' @return a data.frame with available dataflows
#' @example example/sdmx_v2_1_get_dataflows.R
#' @export
sdmx_v2_1_get_dataflows <- function(
    req = NULL,
    agencyID = NULL
){

  path <- tempfile("sdmx", fileext = ".json")

  resp <-
    sdmx_v2_1_structure_request(
    req = req,
    resource = "dataflow",
    agencyID = agencyID
  ) |>
    httr2::req_perform(path = path)

  #TODO check resp

  res <- jsonlite::fromJSON(path, simplifyVector = TRUE)


  # TODO provide a "raw" option that returns the full response

  dataflows <- res$data$dataflows

  # we add ref to the dataflows for convenience, to be used as a flowRef
  dataflows$ref <- with(dataflows, {
      paste(agencyID, id, version, sep = ",")
  })

  structure(
    dataflows,
    contentLanguages = res$meta$contentLanguages
  )
}
