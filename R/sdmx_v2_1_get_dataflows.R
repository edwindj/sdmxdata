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
  resp <-
    sdmx_v2_1_structure_request(
    req = req,
    resource = "dataflow",
    agencyID = agencyID
  ) |>
    httr2::req_perform()

  res <-
    resp |>
    httr2::resp_body_json(simplifyVector = TRUE)


  # TODO provide a "raw" option that returns the full response

  dataflows <- res$data$dataflows

  # we add flowRefs to the dataflows for convenience
  dataflows$flowRefs <- with(dataflows, {
      paste(agencyID, id, version, sep = ",")
  })

  structure(
    dataflows,
    contentLanguages = res$meta$contentLanguages
  )
}
