
get_dataflows <- function(
    req = NULL,
    agencyID = NULL
){
  resp <-
    sdmx_rest_structure_query(
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
  # url <- sprintf(
  #   "https://lustat.statec.lu/rest/dataflow/%s",
  #   #"https://sdmx-api.beta.cbs.nl/rest/dataflow/%s",
  #   agencyID
  # )
  # dfs <- get_meta_json(url)
  # # extract extra info?
  #
  # flows <- dfs$data$dataflows
  #
  # flows
}

# get_flowRefs <- function(x){
#   paste(x$agencyID, x$id, x$version, sep = ",")
# }
